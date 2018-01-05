//
//  BlueToothViewController.swift
//  DemoProject
//
//  Created by 張立 on 2017/12/28.
//  Copyright © 2017年 張立. All rights reserved.
//

import UIKit
import CoreBluetooth

class BlueToothViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var manager : CBCentralManager!
    
    var discoveredPeripheralsArr:[CBPeripheral] = []
    
    //當前連接的設備
    var connectedPeripheral : CBPeripheral!
    //當前連接的設備特性
    var savedCharacteristic : CBCharacteristic!
    
    let ServiceUUID1 =  "180A"
    
    var lastString : NSString!
    var sendString : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationItem.title="BlueTooth藍芽連接"
        
        let btnScan = UIButton.init(type: UIButtonType.custom)
        btnScan.setTitle("Scan", for: UIControlState.normal)
        btnScan.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btnScan.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnScan.addTarget(self, action: #selector(self.scan(_:)), for: UIControlEvents.touchUpInside)
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem.init(customView: btnScan)
        
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
        
        centralManagerDidUpdateState(manager)
        
    }
    
    @IBAction func scan(_ sender: Any) {
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func simpleHint() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "提示",
            message: "一個簡單提示，請按確認繼續",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil
        )
    }
    
}
extension BlueToothViewController :CBCentralManagerDelegate,CBPeripheralDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("BT ON")
        case .poweredOff:
            print("BT OFF")
        case .unknown:
            print("BT UNKNOW")
        case .resetting:
            print("BT RESSTING")
        case .unsupported:
            print("BT UNSUPPORTED")
        case .unauthorized:
            print("BT UNAUTHORIZED")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var isExisted = false
        for obtainedPeriphal  in discoveredPeripheralsArr {
            if (obtainedPeriphal.identifier == peripheral.identifier){
                isExisted = true
            }
            //            print(obtainedPeriphal?.name)
            print(discoveredPeripheralsArr.count)
            print(obtainedPeriphal.name)
        }
        
        if !isExisted{
            discoveredPeripheralsArr.append(peripheral)
        }
        
        tableview.reloadData()
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("didconnect the peripheral name is \(peripheral.name)")
        
        connectedPeripheral = peripheral
        //尋找服務
        peripheral .discoverServices(nil)
        
        peripheral.delegate = self
        self.title = peripheral.name
        
        //停止掃描
        manager .stopScan()
        
        
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "提示",
            message: "按下確認傳送Hello World",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                
                let data = "Hello World".data(using: .utf8)
                self.viewController(peripheral, didWriteValueFor: self.savedCharacteristic, value: data!)
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil
        )
        

    }
    
    func viewController(_ peripheral: CBPeripheral,didWriteValueFor characteristic: CBCharacteristic,value : Data ) -> () {
        
        //只有 characteristic.properties 唯write的時候才可寫入
        if characteristic.properties.contains(CBCharacteristicProperties.write){
            //設置為寫入有回傳
            self.connectedPeripheral.writeValue(value, for: characteristic, type: .withResponse)
        }else{
            print("不可寫入資料")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("連接失敗，原因:\(error)")
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("連接斷開，原因+\(error)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if (error != nil){
            print("訪問 services  \(peripheral.name) 出現錯誤 \(error?.localizedDescription)")
        }
        
        for service in peripheral.services! {

            if service.uuid.uuidString == ServiceUUID1{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil{
            print("找尋 characteristics  \(peripheral.name) 出現錯誤 \(error?.localizedDescription)")
        }
        
        //获取Characteristic的值，读到数据会进入方法：
        //        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
        
        for characteristic in service.characteristics! {
            peripheral .readValue(for: characteristic)
            
            //设置 characteristic 的 notifying 属性 为 true ， 表示接受广播
            
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
        let resultStr = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
        
        print("characteristic uuid:\(characteristic.uuid)   value:\(resultStr)")
        
        if lastString == resultStr{
            return;
        }
        
        // 將裝置特徵保存
        self.savedCharacteristic = characteristic
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        if error != nil{
            print("寫入 characteristics 時 \(peripheral.name) 出現錯誤 \(error?.localizedDescription)")
        }
        
        let alertView = UIAlertController.init(title: "抱歉", message: "寫入成功", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "好的", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        alertView.show(self, sender: nil)
        lastString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
        
    }
    
    
}
extension BlueToothViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPeripheralsArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        let peripheral = discoveredPeripheralsArr[indexPath.row]
        print(peripheral.name)
        cell?.textLabel?.text = String.init(format: "設備名稱 ：%@", (peripheral.name)!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = discoveredPeripheralsArr[indexPath.row]
        manager.connect(selectedPeripheral, options: nil)
        
    }
    
}
