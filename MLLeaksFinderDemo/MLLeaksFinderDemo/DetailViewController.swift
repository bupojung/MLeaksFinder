//
//  DetailViewController.swift
//  MLLeaksFinderDemo
//
//  Created by bupozhuang on 2018/12/19.
//  Copyright © 2018 bytedance. All rights reserved.
//

import UIKit
import RxSwift


class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    deinit {
        print("deinit")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("resource count:\(Resources.total)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        let ob = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        ob.subscribe()
        
        
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

