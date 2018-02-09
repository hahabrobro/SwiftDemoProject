//
//  RxSwiftDemoViewController.swift
//  DemoProject
//
//  Created by 張立 on 2018/1/29.
//  Copyright © 2018年 張立. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftDemoViewController: UIViewController {
    
    let disposeBag = DisposeBag();
    
    @IBOutlet var txtField: UITextField!
    @IBOutlet var lblCount: UILabel!
    
    @IBOutlet var TextField: UITextField!
    @IBOutlet var TextFieldLabel: UILabel!
    
    @IBOutlet var btn: UIButton!
    @IBOutlet var btnlbl: UILabel!
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var stepperlbl: UILabel!
    
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerlbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="RxSwift基礎UI互動"
        
        // Do any additional setup after loading the view.
        
        //監聽者,被監聽者,回收
        TextField.rx.text.bind(to:TextFieldLabel.rx.text).disposed(by: disposeBag)
        
        //drive 有三個特性，不能出錯，放在主線呈上，資源共享
        txtField.rx.text.orEmpty.asDriver().map{g in "總數共\(g.count)"}.drive(lblCount.rx.text).disposed(by: disposeBag)
        
        btn.rx.tap.bind{
            self.btnlbl.text! += "別按了!"
            self.view.endEditing(true)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }.disposed(by: disposeBag)
        
        slider.rx.value.bind(to:progressView.rx.progress).disposed(by: disposeBag)
        
        stepper.rx.value.map{
            g in String(Int(g))
        }.bind(to: stepperlbl.rx.text).disposed(by: disposeBag)
        
        datePicker.rx.date.map{
            g in "你選擇到的是\(g)"
            }.bind(to: datePickerlbl.rx.text).disposed(by: disposeBag)
        
        datePicker.rx.date.map{
            g in "你選擇到的是\(g)"
            }.bind(to: datePickerlbl.rx.text).disposed(by: disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
