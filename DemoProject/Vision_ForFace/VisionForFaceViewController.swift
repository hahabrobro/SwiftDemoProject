//
//  VisionForFaceViewController.swift
//  DemoProject
//
//  Created by 張立 on 2018/1/5.
//  Copyright © 2018年 張立. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class VisionForFaceViewController: UIViewController {

    @IBOutlet weak var buttonTargetImage: UIButton!
    @IBOutlet weak var buttonOriginalImage: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var selectImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pressedChoosePhoto(_ sender: UIButton) {
        self.chooseImage()
    }
    func processImage(image:UIImage) {
        self.preformRequestForFaceRectangle(image: image)
        //
        self.selectImage=image
        
    }
    func preformRequestForFaceRectangle(image:UIImage) {
        self.resultLabel.text="處理中"
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        
        do{
            let request = VNDetectFaceRectanglesRequest(completionHandler: nil)
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    func handleFaceFetection(request:VNRequest,error:Error?) {
        //no face
        guard let observations=request.results as? [VNFaceObservation] else {
            fatalError("No_face !")
        }
        
        self.resultLabel.text="找到 \(observations.count) 張臉"
        for faceobservation in observations {
            self.addFaceContour(forObservation: faceobservation, toView: self.buttonOriginalImage)
        }
    }
    
    func addFaceContour(forObservation face:VNFaceObservation,toView view:UIView) {
        //畫出輪廓
        //計算輪廓大小
    }


}
extension VisionForFaceViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard  let uiImage=info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("no image selected")
        }
        
        self.buttonOriginalImage.setBackgroundImage(uiImage, for: .normal)
        self.processImage(image: uiImage)
    }
}

