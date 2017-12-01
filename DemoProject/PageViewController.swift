//
//  PageViewController.swift
//  DemoProject
//
//  Created by 張立 on 2017/12/1.
//  Copyright © 2017年 張立. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index=viewlist.index(of: viewController),index>0
        {
            return viewlist[index-1]
        }
        else
        {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index=viewlist.index(of: viewController),index < viewlist.count-1
        {
            return viewlist[index+1]
        }
        else
        {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewlist.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    var viewlist=[UIViewController]();
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1=Page1ViewController()
        let vc2=Page2ViewController()
        let vc3=Page3ViewController()
        
        viewlist.append(vc1)
        viewlist.append(vc2)
        viewlist.append(vc3)
        
        setViewControllers([viewlist[0]], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
        dataSource=self
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
