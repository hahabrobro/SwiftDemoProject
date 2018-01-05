//
//  HomePageViewController.swift
//  DemoProject
//
//  Created by 張立 on 2017/11/28.
//  Copyright © 2017年 張立. All rights reserved.
//

import UIKit
import SDWebImage
class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var info = [
        [
            DemoProjectList.AutolayoutTutorial,
            DemoProjectList.PageViewControllerTutorial,
            DemoProjectList.AccessRemoteAPItoTableView
        ],
        [
            DemoProjectList.iBeacon,
            DemoProjectList.BlueTooth,
            DemoProjectList.CoreML,
            DemoProjectList.Vision
        ]
    ]
    enum DemoProjectList {
        case AutolayoutTutorial
        case PageViewControllerTutorial
        case AccessRemoteAPItoTableView
        //Section 2
        case iBeacon
        case BlueTooth
        case CoreML
        case Vision
    }
    @IBOutlet weak var HomeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        HomeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "DemoListTableViewCell")
//        tb.register(UINib.init(nibName: "MyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell");
        HomeTableView.register(UINib.init(nibName: "HomeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DemoListTableViewCell")
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 有幾組 section
    func numberOfSections(in tableView: UITableView) -> Int {
        return info.count
    }
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = section == 0 ? "基本功能" : "進階功能"
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得 tableView 目前使用的 cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoListTableViewCell", for: indexPath) as! HomeTableViewCell
        
        // 設置 Accessory 按鈕樣式
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.accessoryType = .checkmark
            } else if indexPath.row == 1 {
                cell.accessoryType = .detailButton
            } else if indexPath.row == 2 {
                cell.accessoryType = .detailDisclosureButton
            } else if indexPath.row == 3 {
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        if let label=cell.HomeTableViewCellLabel {
            label.text="\(info[indexPath.section][indexPath.row])"
        }
        
        // 顯示的內容
//        if let myLabel = cell.textLabel {
//            myLabel.text = "\(info[indexPath.section][indexPath.row])"
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var whichcase=info[indexPath.section][indexPath.row];
        switch whichcase {
        case .AutolayoutTutorial:
            self.navigationController?.pushViewController(AutolayoutTutorialViewController(), animated: true)
        case .PageViewControllerTutorial:
            self.navigationController?.pushViewController(PageViewController(), animated: true)
        case .AccessRemoteAPItoTableView:
            self.navigationController?.pushViewController(RemoteAPITableViewViewController(), animated: true)
        case .iBeacon:
            self.navigationController?.pushViewController(iBeaconViewController(), animated: true)
        case .BlueTooth:
            self.navigationController?.pushViewController(BlueToothViewController(), animated: true)
        case .CoreML:
            self.navigationController?.pushViewController(CoreMLViewController(), animated: true)
        case .Vision:
            self.navigationController?.pushViewController(VisionViewController(), animated: true)
        
        default:
            print(whichcase)
        }
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
