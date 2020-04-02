//
//  ViewController.swift
//  Swift无限轮播
//
//  Created by 运满满 on 2020/4/2.
//  Copyright © 2020 jimwan. All rights reserved.
//

import UIKit
import SnapKit

let cyleViewH:CGFloat = 300

class ViewController: UIViewController {

    let imageNames = ["1","2","3","4","5"]
    lazy var cycleView:CycleView = {
        let naviH = self.navigationController?.navigationBar.frame.height
        let statusH = UIApplication.shared.statusBarFrame.height

        var cycleView = CycleView(frame: CGRect(x: 0, y: naviH! + statusH, width: kScreenWidth, height: cyleViewH), images:imageNames)
        cycleView.backgroundColor = UIColor.red
        cycleView.delegate = self
        return cycleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       setupViews()
    }


    func setupViews(){
        navigationController?.navigationBar.barTintColor = .orange
        view.addSubview(cycleView)
    }
}

extension ViewController:CycleViewDelegate{
    func cellDidSellected(_ cycleView: CycleView, ofIndex index: Int) {
        print("selected \(index)")
    }
    
    
}
