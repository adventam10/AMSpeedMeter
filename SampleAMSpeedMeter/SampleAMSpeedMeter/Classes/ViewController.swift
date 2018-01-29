//
//  ViewController.swift
//  SampleAMSpeedMeter
//
//  Created by am10 on 2018/01/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sView1: AMSpeedMeterView!
    @IBOutlet weak var sView2: AMSpeedMeterView!
    @IBOutlet weak var sView3: AMSpeedMeterView!
    
    private var timer:Timer?
    private let speedMeterView = AMSpeedMeterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sView2.decimalFormat = .first
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(self.timerAction(teimer:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func timerAction(teimer:Timer) {
        
        let value1 = CGFloat(arc4random() % 100)
        sView1.currentValue = value1

        let value2 = CGFloat(arc4random() % 90)
        sView2.currentValue = value2

        var value3 = CGFloat(arc4random() % 200)
        if value3 < 100 {

            value3 += 100
        }
        sView3.currentValue = -1.0*value3
    }
}

