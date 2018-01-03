//
//  VisionViewController.swift
//  DemoProject
//
//  Created by 張立 on 2017/12/24.
//  Copyright © 2017年 張立. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class VisionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var session = AVCaptureSession()
    
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Vision文字識別"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startLiveVideo()
        startTextDetection()
    }
    
    func startLiveVideo() {
        
        //1.修改AVCaptureSession的設定，而且持續運作
        session.sessionPreset=AVCaptureSession.Preset.photo
        let  caputerDevice = AVCaptureDevice.default(for: .video)
        
        //2.定義裝置的輸入以及輸出，輸入kCVPixelFormatType_32BGRA格式 然後輸出 AVcaptureSession
        let deviceInput = try! AVCaptureDeviceInput(device: caputerDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String :Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    
    //1. Request 要求Vision去偵測
    //2. Handler 用來處理偵測到的東西
    //3. Observation 展示結果
    //AVFoundtion + CoreML = Vision
    
    //開始文字識別
    func startTextDetection() {
        
        let TextRequest=VNDetectTextRectanglesRequest(completionHandler: self.detecTextHanler)
        //識別框框是否打開
        TextRequest.reportCharacterBoxes=true
        self.requests=[TextRequest]
    }
    
    func  detecTextHanler(request:VNRequest,error:Error?) {
        guard let observation=request.results else {
            //print("nothink")
            //return
            //79行=76+77
            fatalError("noResults")
        }
        let results = observation.map({$0 as? VNTextObservation})
        
        DispatchQueue.main.async {
            self.imageView.layer.sublayers?.removeSubrange(1...)
            for region in results {
                guard let rg = region else {continue}
                self.hightlightWord(box: rg)
                
                if let boxes = region?.characterBoxes {
                    for characterBox in boxes {
                        self.highlightLetters(box: characterBox)
                    }
                }
            }
        }
        
    }
    func hightlightWord(box:VNTextObservation) {
        guard let boxs=box.characterBoxes else {
            fatalError("noboxs")
        }
        
        //最大字，最小字大小設置
        var maxX:CGFloat=9999.0;
        var maxY:CGFloat=9999.0;
        var minX:CGFloat=0.0;
        var minY:CGFloat=0.0;
        
        for char in boxs {
            
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
            
        }
        
        
        let outLine = CALayer()
        //        DispatchQueue.main.async{
        
        let xCord=maxX * self.imageView.frame.size.width
        let yCord=(1-minY) * self.imageView.frame.size.height
        
        let width = (minX-maxX) * self.imageView.frame.size.width
        let height = (minY - maxY) * self.imageView.frame.size.height
        
        
        outLine.frame=CGRect(x: xCord, y: yCord, width: width, height: height)
        outLine.borderWidth=0.2
        outLine.borderColor=UIColor.red.cgColor
        //        }
        self.imageView.layer.addSublayer(outLine)
    }
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * imageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        imageView.layer.addSublayer(outline)
    }


}
extension VisionViewController:AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixebuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            fatalError("掛了")
        }
        var requestOptions :[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil){
            requestOptions = [.cameraIntrinsics:camData]
        }
        let imageRequestHandler=VNImageRequestHandler(cvPixelBuffer: pixebuffer, orientation: CGImagePropertyOrientation.init(rawValue: 6)!, options: requestOptions)
        do{
            try imageRequestHandler.perform(self.requests)
        }catch{
            
            print(error)
        }
    }
}
