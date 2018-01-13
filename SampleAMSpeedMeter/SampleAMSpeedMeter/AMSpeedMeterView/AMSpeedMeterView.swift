//
//  AMSpeedMeterView.swift
//  TestProject
//
//  Created by am10 on 2017/12/31.
//  Copyright © 2017年 am10. All rights reserved.
//

import UIKit

/// 目盛りラベルの小数表示形式
enum AMSMDecimalFormat {
    case none // 小数なし
    case first // 小数第一位まで
    case second // 小数第二位まで
}

@IBDesignable class AMSpeedMeterView: UIView {

    override var bounds: CGRect {
        
        didSet {
            
            reloadMeter()
        }
    }
    
    var decimalFormat:AMSMDecimalFormat = .none
    
    @IBInspectable var maxValue:CGFloat = 100
    
    @IBInspectable var minValue:CGFloat = 0
    
    @IBInspectable var numberOfValue:Int = 5
    
    /// メーターの枠線の幅
    @IBInspectable var meterBorderLineWidth:CGFloat = 5
    
    /// 値目盛りの太さ
    @IBInspectable var valueIndexWidth:CGFloat = 2.0
    
    /// 針の太さ
    @IBInspectable var valueHandWidth:CGFloat = 3.0
    
    /// メーターの枠線の色
    @IBInspectable var meterBorderLineColor:UIColor = UIColor.black
    
    /// メーターの色
    @IBInspectable var meterColor:UIColor = UIColor.clear
    
    /// 針の色
    @IBInspectable var valueHandColor:UIColor = UIColor.red
    
    /// 値の文字色
    @IBInspectable var valueLabelTextColor:UIColor = UIColor.black
    
    /// 値目盛りの色
    @IBInspectable var valueIndexColor:UIColor = UIColor.black
    
    /// メーターの上下左右の余白
    private let meterSpace:CGFloat = 10
    
    private let minAngle:Float = Float(Double.pi)
    
    private let maxAngle:Float = Float(Double.pi*2)
    
    private let meterView = UIView()
    
    private var drawLayer:CAShapeLayer?
    
    private var valueHandLayer:CAShapeLayer?
    
    private var startAngle:Float = Float(Double.pi)
    
    private var endAngle:Float = 0.0
    
    var currentValue:CGFloat = 0.0 {
        
        didSet {
            
            if currentValue < minValue {
                
                currentValue = minValue
                
            } else if currentValue > maxValue {
                
                currentValue = maxValue
            }
            
            endAngle = calculateAngle(value: currentValue)
            handAnimation()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        reloadMeter()
    }
    
    //MARK:Prepare
    private func prepareMeterView() {
        
        var length:CGFloat = (frame.width < frame.height) ? frame.width : frame.height
        length -= meterSpace * 2
        meterView.frame = CGRect(x: frame.width/2 - length/2,
                                 y: frame.height/2 - length/2,
                                 width: length,
                                 height: length)
        meterView.backgroundColor = UIColor.clear
        addSubview(meterView)
    }
    
    private func prepareDrawLayer() {
        
        drawLayer = CAShapeLayer()
        guard let drawLayer = drawLayer else {
            
            return
        }
        
        drawLayer.frame = meterView.bounds
        meterView.layer.addSublayer(drawLayer)
        drawLayer.cornerRadius = meterView.frame.width/2
        drawLayer.masksToBounds = true
        drawLayer.borderWidth = meterBorderLineWidth
        drawLayer.borderColor = meterBorderLineColor.cgColor
        drawLayer.backgroundColor = meterColor.cgColor
    }
    
    private func prepareValueIndexLayer() {
        
        guard let drawLayer = drawLayer else {
            
            return
        }
        
        let layer = CAShapeLayer()
        layer.frame = drawLayer.bounds
        drawLayer.addSublayer(layer)
        layer.strokeColor = valueIndexColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        var angle:Float = minAngle
        let radius = meterView.frame.width/2
        let centerPoint = CGPoint(x: radius, y: radius)
        let smallRadius = radius - (radius/10 + meterBorderLineWidth)
        
        let path = UIBezierPath()
        let angleUnit = (numberOfValue > 0) ? (maxAngle-minAngle)/Float(numberOfValue-1) : 0.0
        
        // 中心から外への線描画
        for i in 0..<numberOfValue {
            
            if i == numberOfValue-1 {
                
                angle = maxAngle
            }
            let point = CGPoint(x: centerPoint.x + radius * CGFloat(cosf(angle)),
                                y: centerPoint.y + radius * CGFloat(sinf(angle)))
            path.move(to: point)
            let point2 = CGPoint(x: centerPoint.x + smallRadius * CGFloat(cosf(angle)),
                                 y: centerPoint.y + smallRadius * CGFloat(sinf(angle)))
            path.addLine(to: point2)
            
            angle += angleUnit
        }
        
        layer.lineWidth = valueIndexWidth
        layer.path = path.cgPath
    }
    
    private func prepareValueLabel() {
        
        var angle:Float = minAngle
        let radius = meterView.frame.width/2
        let centerPoint = CGPoint(x: radius, y: radius)
        var smallRadius = radius - (radius/10 + meterBorderLineWidth)
        let length = radius/4
        smallRadius -= length/2
        
        let angleUnit = (numberOfValue > 0) ? (maxAngle-minAngle)/Float(numberOfValue-1) : 0.0
        let valueUnit = (numberOfValue > 0) ? (maxValue-minValue)/CGFloat(numberOfValue-1) : 0.0
        var value = minValue
        // 中心から外への線描画
        for i in 0..<numberOfValue {
            
            if i == numberOfValue-1 {
                
                angle = maxAngle
                value = maxValue
            }
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: length, height: length))
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.textColor = valueLabelTextColor
            
            switch decimalFormat {
                
            case .none:
                label.text = NSString(format: "%.0f", value) as String
                break
            case .first:
                label.text = NSString(format: "%.1f", value) as String
                break
            case .second:
                label.text = NSString(format: "%.2f", value) as String
                break
            }
            
            label.font = adjustFont(rect: label.frame)
            meterView.addSubview(label)
            let point = CGPoint(x: centerPoint.x + smallRadius * CGFloat(cosf(angle)),
                                y: centerPoint.y + smallRadius * CGFloat(sinf(angle)))
            label.center = point
            angle += angleUnit
            value += valueUnit
        }
    }
    
    private func prepareValueHandLayer() {
        
        guard let drawLayer = drawLayer else {
            
            return
        }
        
        valueHandLayer = CAShapeLayer()
        guard let valueHandLayer = valueHandLayer else {
            
            return
        }
        
        valueHandLayer.frame = drawLayer.bounds
        drawLayer.addSublayer(valueHandLayer)
        valueHandLayer.strokeColor = valueHandColor.cgColor
        valueHandLayer.fillColor = UIColor.clear.cgColor
        
        let angle:Float = minAngle
        
        let radius = meterView.frame.width/2
        let length = radius * 0.8
        let centerPoint = CGPoint(x: radius, y: radius)
        
        let path = UIBezierPath()
        let point = CGPoint(x: centerPoint.x + length * CGFloat(cosf(angle)),
                            y: centerPoint.y + length * CGFloat(sinf(angle)))
        path.move(to: centerPoint)
        path.addLine(to: point)
        
        valueHandLayer.lineWidth = valueHandWidth
        valueHandLayer.path = path.cgPath
    }
    
    //MARK:Animation
    private func handAnimation() {
        
        guard let valueHandLayer = valueHandLayer else {
            
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [unowned self] in
            
            let animation = valueHandLayer.animation(forKey: "rotateAnimation")
            if animation != nil {
                
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue,
                                       forKey: kCATransactionDisableActions)
                
                let radius = self.meterView.frame.width/2
                let length = radius * 0.8
                let centerPoint = CGPoint(x: radius, y: radius)
                
                let path = UIBezierPath()
                let point = CGPoint(x: centerPoint.x + length * CGFloat(cosf(self.endAngle)),
                                    y: centerPoint.y + length * CGFloat(sinf(self.endAngle)))
                path.move(to: centerPoint)
                path.addLine(to: point)
                
                valueHandLayer.removeAnimation(forKey: "rotateAnimation")
                
                valueHandLayer.path = path.cgPath
                CATransaction.commit()
            }
        }
       
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.toValue = endAngle - startAngle
        rotationAnimation.duration = 0.2
        rotationAnimation.isRemovedOnCompletion = false
        startAngle = endAngle
        valueHandLayer.add(rotationAnimation, forKey: "rotateAnimation")
        CATransaction.commit()
    }
    
    //MARK:Calculate
    private func calculateAngle(value: CGFloat) -> Float {
        
        var rate:Float = 0
        if minValue < 0 {
            
            rate = Float((value - minValue) / (maxValue - minValue))
            
        } else {
            
            rate = Float(value / (maxValue - minValue))
        }
        
        let angle:Float = (maxAngle - minAngle) * rate
        return angle + minAngle
    }
    
    private func adjustFont(rect: CGRect) -> UIFont {
        
        let length:CGFloat = (rect.width > rect.height) ? rect.height : rect.width
        let font = UIFont.systemFont(ofSize: length * 0.8)
        return font
    }
    
    //MARK:Clear/Reload
    private func clear() {
        
        meterView.subviews.forEach{$0.removeFromSuperview()}
        meterView.removeFromSuperview()
        drawLayer?.removeFromSuperlayer()
        drawLayer = nil
        valueHandLayer = nil
    }
    
    func reloadMeter() {
        
        clear()
    
        prepareMeterView()
        prepareDrawLayer()
        prepareValueIndexLayer()
        prepareValueLabel()
        prepareValueHandLayer()
    }
}
