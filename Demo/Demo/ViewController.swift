//
//  ViewController.swift
//  Demo
//
//  Created by bupozhuang on 2018/12/24.
//  Copyright © 2018 bytedance. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func push(_ sender: Any) {
        let aVC = AViewController()
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func present(_ sender: Any) {
        let bVC = BViewController()
        self.present(bVC, animated: true, completion: nil)
    }
}

