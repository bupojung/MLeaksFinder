//
//  AViewController.swift
//  Demo
//
//  Created by bupozhuang on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

import UIKit
import RxSwift

class AViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let ob = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        ob.subscribe()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
