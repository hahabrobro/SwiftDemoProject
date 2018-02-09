//
//  RxSwiftTableViewController.swift
//  DemoProject
//
//  Created by 張立 on 2018/1/25.
//  Copyright © 2018年 張立. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftTableViewController: UIViewController {
    
    let disposeBag=DisposeBag()
    
    @IBOutlet var tableview: UITableView!
    
    let items = Observable.of(
        (0...20).map{ "\($0)" }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //bind寫法
//        items
//            .bindTo(tableview.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){
//                (_, elememt, cell) in
//                cell.textLabel?.text = elememt
//            }.disposed(by: disposeBag)
        
        items.asDriver(onErrorJustReturn:[]).drive(tableview.rx.items(cellIdentifier: "Cell")){
            (_, elememt, cell) in
            cell.textLabel?.text = "\(elememt)"
            }.disposed(by: disposeBag)
        
        tableview.rx.modelSelected(String.self).subscribe(onNext:{
            value in
            print("click \(value)")
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
