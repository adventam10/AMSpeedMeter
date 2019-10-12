//
//  AMSpeedMeterView.swift
//  AMSpeedMeter, https://github.com/adventam10/AMSpeedMeter
//
//  Created by am10 on 2017/12/31.
//  Copyright © 2017年 am10. All rights reserved.
//

import UIKit

public enum AMSMDecimalFormat {
    case none
    case first
    case second
    
    func formattedValue(_ value: CGFloat) -> String {
        switch self {
        case .none:
            return String(format: "%.0f", value)
        case .first:
            return String(format: "%.1f", value)
        case .second:
            return String(format: "%.2f", value)
        }
    }
}

@IBDesignable public class AMSpeedMeterView: UIView {
    
    @IBInspectable public var maxValue: CGFloat = 100
    @IBInspectable public var minValue: CGFloat = 0
    @IBInspectable public var numberOfValue: Int = 5
    @IBInspectable public var meterBorderLineWidth: CGFloat = 5
    @IBInspectable public var valueIndexWidth: CGFloat = 2.0
    @IBInspectable public var valueHandWidth: CGFloat = 3.0
    @IBInspectable public var meterBorderLineColor: UIColor = .black
    @IBInspectable public var meterColor: UIColor = .clear
    @IBInspectable public var valueHandColor: UIColor = .red
    @IBInspectable public var valueLabelTextColor: UIColor = .black
    @IBInspectable public var valueIndexColor: UIColor = .black
    public var decimalFormat: AMSMDecimalFormat = .none
    public var currentValue: CGFloat = 0.0 {
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
    
    override public var bounds: CGRect {
        didSet {
            reloadMeter()
        }
    }
    
    private let meterSpace: CGFloat = 10
    private let minAngle: Float = Float(Double.pi)
    private let maxAngle: Float = Float(Double.pi*2)
    private let meterView = UIView()
    
    private var drawLayer: CAShapeLayer?
    private var valueHandLayer: CAShapeLayer?
    private var startAngle: Float = Float(Double.pi)
    private var endAngle: Float = 0.0
    private var radius: CGFloat {
        return meterView.frame.width/2
    }
    private var meterCenter: CGPoint {
        return .init(x: radius, y: radius)
    }
    private var handLength: CGFloat {
        return radius * 0.8
    }
    
    override public func draw(_ rect: CGRect) {
        reloadMeter()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    // MARK:- Prepare View
    private func prepareMeterView() {
        var length = (frame.width < frame.height) ? frame.width : frame.height
        length -= meterSpace * 2
        meterView.frame = CGRect(x: frame.width/2 - length/2,
                                 y: frame.height/2 - length/2,
                                 width: length,
                                 height: length)
        meterView.backgroundColor = .clear
        addSubview(meterView)
    }
    
    private func prepareValueLabel() {
        var angle = minAngle
        var smallRadius = radius - (radius/10 + meterBorderLineWidth)
        let length = radius/4
        smallRadius -= length/2
        
        let angleUnit = (numberOfValue > 0) ? (maxAngle-minAngle)/Float(numberOfValue-1) : 0.0
        let valueUnit = (numberOfValue > 0) ? (maxValue-minValue)/CGFloat(numberOfValue-1) : 0.0
        var value = minValue
        // draw line (from center to out)
        for i in 0..<numberOfValue {
            if i == numberOfValue-1 {
                angle = maxAngle
                value = maxValue
            }
            let label = makeLabel(length: length)
            label.textColor = valueLabelTextColor
            label.text = decimalFormat.formattedValue(value)
            label.font = adjustFont(rect: label.frame)
            meterView.addSubview(label)
            label.center = CGPoint(x: meterCenter.x + smallRadius * CGFloat(cosf(angle)),
                                   y: meterCenter.y + smallRadius * CGFloat(sinf(angle)))
            angle += angleUnit
            value += valueUnit
        }
    }
    
    private func makeLabel(length: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: length, height: length))
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        return label
    }
    
    // MARK:- Make Layer
    private func makeDrawLayer() -> CAShapeLayer {
        let drawLayer = CAShapeLayer()
        drawLayer.frame = meterView.bounds
        drawLayer.cornerRadius = radius
        drawLayer.masksToBounds = true
        drawLayer.borderWidth = meterBorderLineWidth
        drawLayer.borderColor = meterBorderLineColor.cgColor
        drawLayer.backgroundColor = meterColor.cgColor
        return drawLayer
    }
    
    private func makeValueIndexLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = drawLayer!.bounds
        layer.strokeColor = valueIndexColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = valueIndexWidth
        
        var angle = minAngle
        let smallRadius = radius - (radius/10 + meterBorderLineWidth)
        
        let path = UIBezierPath()
        let angleUnit = (numberOfValue > 0) ? (maxAngle-minAngle)/Float(numberOfValue-1) : 0.0
        
        // draw line (from center to out)
        for i in 0..<numberOfValue {
            if i == numberOfValue-1 {
                angle = maxAngle
            }
            let start = CGPoint(x: meterCenter.x + radius * CGFloat(cosf(angle)),
                                y: meterCenter.y + radius * CGFloat(sinf(angle)))
            path.move(to: start)
            let end = CGPoint(x: meterCenter.x + smallRadius * CGFloat(cosf(angle)),
                              y: meterCenter.y + smallRadius * CGFloat(sinf(angle)))
            path.addLine(to: end)
            
            angle += angleUnit
        }
        
        layer.path = path.cgPath
        return layer
    }
    
    private func makeValueHandLayer() -> CAShapeLayer {
        let valueHandLayer = CAShapeLayer()
        valueHandLayer.frame = drawLayer!.bounds
        valueHandLayer.strokeColor = valueHandColor.cgColor
        valueHandLayer.fillColor = UIColor.clear.cgColor
        valueHandLayer.lineWidth = valueHandWidth
        valueHandLayer.path = makeHandPath(angle: minAngle).cgPath
        return valueHandLayer
    }
    
    private func makeHandPath(angle: Float) -> UIBezierPath {
        let path = UIBezierPath()
        let point = CGPoint(x: meterCenter.x + handLength * CGFloat(cosf(angle)),
                            y: meterCenter.y + handLength * CGFloat(sinf(angle)))
        path.move(to: meterCenter)
        path.addLine(to: point)
        return path
    }
    
    // MARK:- Animation
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
                valueHandLayer.removeAnimation(forKey: "rotateAnimation")
                valueHandLayer.path = self.makeHandPath(angle: self.endAngle).cgPath
                CATransaction.commit()
            }
        }
       
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fillMode = .forwards
        rotationAnimation.toValue = endAngle - startAngle
        rotationAnimation.duration = 0.2
        rotationAnimation.isRemovedOnCompletion = false
        startAngle = endAngle
        valueHandLayer.add(rotationAnimation, forKey: "rotateAnimation")
        CATransaction.commit()
    }
    
    // MARK:- Calculate
    private func calculateAngle(value: CGFloat) -> Float {
        var rate: Float = 0
        if minValue < 0 {
            rate = Float((value - minValue) / (maxValue - minValue))
        } else {
            rate = Float(value / (maxValue - minValue))
        }
        
        let angle: Float = (maxAngle - minAngle) * rate
        return angle + minAngle
    }
    
    private func adjustFont(rect: CGRect) -> UIFont {
        let length = (rect.width > rect.height) ? rect.height : rect.width
        return .systemFont(ofSize: length * 0.8)
    }
    
    // MARK:- Clear/Reload
    private func clear() {
        meterView.subviews.forEach { $0.removeFromSuperview() }
        meterView.removeFromSuperview()
        drawLayer?.removeFromSuperlayer()
        drawLayer = nil
        valueHandLayer = nil
    }
    
    public func reloadMeter() {
        clear()
    
        prepareMeterView()
        
        drawLayer = makeDrawLayer()
        meterView.layer.addSublayer(drawLayer!)
        
        drawLayer!.addSublayer(makeValueIndexLayer())
    
        prepareValueLabel()
        
        valueHandLayer = makeValueHandLayer()
        drawLayer!.addSublayer(valueHandLayer!)
    }
}
