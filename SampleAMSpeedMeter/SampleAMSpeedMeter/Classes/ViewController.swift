//
//  ViewController.swift
//  SampleAMSpeedMeter
//
//  Created by am10 on 2018/01/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var sView1: AMSpeedMeterView!
    @IBOutlet weak private var sView2: AMSpeedMeterView!
    @IBOutlet weak private var sView3: AMSpeedMeterView!
    
    private var timer: Timer?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sView1.minValue = 100
        sView1.maxValue = 200
        sView2.valueLabelFont = .boldSystemFont(ofSize: 10)
        sView2.decimalFormat = .first
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(self.timerAction(teimer:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func timerAction(teimer:Timer) {
//        sView1.currentValue = CGFloat.random(in: 0 ... 100)
        sView1.currentValue = CGFloat.random(in: 100 ... 200)
        sView2.currentValue = CGFloat.random(in: 0 ... 90)
        sView3.currentValue = CGFloat.random(in: -200 ... -100)
    }
}

