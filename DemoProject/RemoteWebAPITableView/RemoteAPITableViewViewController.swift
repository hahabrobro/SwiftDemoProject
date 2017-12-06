//
//  RemoteAPITableViewViewController.swift
//  DemoProject
//
//  Created by 張立 on 2017/12/4.
//  Copyright © 2017年 張立. All rights reserved.
//

import UIKit

class RemoteAPITableViewViewController: UIViewController,URLSessionDelegate,URLSessionDownloadDelegate,
UITableViewDelegate, UITableViewDataSource{
    
    var dataArray = [AnyObject]()

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoListTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.HomeTableViewCellLabel.text=dataArray[indexPath.row]["A_Name_Ch"] as? String
        cell.HomeTableViewCellImage.sd_setImage(with: URL(string: (dataArray[indexPath.row]["A_Pic01_URL"] as? String)!), placeholderImage: UIImage(named: "apple.png"))
        
        return cell;
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            
            //JSON資料處理
            let dataDic = try JSONSerialization.jsonObject(with: Data.init(contentsOf: location), options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:[String:AnyObject]]
            
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            
            print(dataArray[0]["A_Name_Ch"])
            let typeString = String(describing: type(of: dataArray))
            print(typeString)
            //重新整理Table View
            self.MainTableView.reloadData()
        } catch {
            print("Error!")
        }
    }
    
    @IBOutlet weak var MainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainTableView.register(UINib.init(nibName: "HomeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DemoListTableViewCell")
        MainTableView.delegate = self
        MainTableView.dataSource = self
        
        //台北市立動物園公開資料網址
        let url = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")
        
        //建立一般的session設定
        let sessionWithConfigure = URLSessionConfiguration.default
        
        //設定委任對象為自己
        let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        //設定下載網址
        let dataTask = session.downloadTask(with: url! as URL)
        
        //啟動或重新啟動下載動作
        dataTask.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
