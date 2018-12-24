//
//  BViewController.swift
//  Demo
//
//  Created by bupozhuang on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

import UIKit
import RxSwift

class BViewController: UIViewController {
    lazy var dismissBtn: UIButton = {
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 60, height: 30))
        button.setTitle("dismiss", for: .normal)
        button.addTarget(self, action: #selector(disss), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(dismissBtn)
        
        let ob = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        ob.subscribe()
        // Do any additional setup after loading the view.
    }
    

    @objc
    func disss() -> Void {
        self.dismiss(animated: true, completion: nil)
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
