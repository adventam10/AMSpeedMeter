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

internal class AMSpeedMeterModel {
    
    let minAngle: Float = Float(Double.pi)
    let maxAngle: Float = Float(Double.pi*2)
    
    var numberOfValue: Int = 5
    var maxValue: CGFloat = 100
    var minValue: CGFloat = 0
    var currentValue: CGFloat = 0.0
    var startAngle: Float = Float(Double.pi)
    var endAngle: Float = 0.0
    var angleUnit: Float {
        return (numberOfValue > 0) ? angleRange/Float(numberOfValue-1) : 0.0
    }
    var valueUnit: CGFloat {
        return (numberOfValue > 0) ? valueRange/CGFloat(numberOfValue-1) : 0.0
    }
    
    private var valueRange: CGFloat {
        return maxValue - minValue
    }
    private var angleRange: Float {
        return maxAngle - minAngle
    }
    
    // MARK:- Calculate
    func calculateAngle(value: CGFloat) -> Float {
        let angle = angleRange * rate(value: value)
        return angle + minAngle
    }
    
    func adjustFont(rect: CGRect) -> UIFont {
        let length = (rect.width > rect.height) ? rect.height : rect.width
        return .systemFont(ofSize: length * 0.8)
    }
    
    private func rate(value: CGFloat) -> Float {
        if minValue < 0 {
            return Float((value - minValue) / valueRange)
        } else {
            return Float(value / valueRange)
        }
    }
}

@IBDesignable public class AMSpeedMeterView: UIView {
    
    @IBInspectable public var maxValue: CGFloat = 100 {
        didSet {
            model.maxValue = maxValue
        }
    }
    @IBInspectable public var minValue: CGFloat = 0 {
        didSet {
            model.minValue = minValue
        }
    }
    @IBInspectable public var numberOfValue: Int = 5 {
        didSet {
            model.numberOfValue = numberOfValue
        }
    }
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
            model.currentValue = currentValue
            model.endAngle = model.calculateAngle(value: currentValue)
            handAnimation()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            reloadMeter()
        }
    }
    
    private let meterView = UIView()
    private let model = AMSpeedMeterModel()
    
    private var drawLayer: CAShapeLayer?
    private var valueHandLayer: CAShapeLayer?
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
        let length = (frame.width < frame.height) ? frame.width : frame.height
        meterView.frame = CGRect(x: frame.width/2 - length/2,
                                 y: frame.height/2 - length/2,
                                 width: length,
                                 height: length)
        meterView.backgroundColor = .clear
        addSubview(meterView)
    }
    
    private func prepareValueLabel() {
        var angle = model.minAngle
        var smallRadius = radius - (radius/10 + meterBorderLineWidth)
        let length = radius/4
        smallRadius -= length/2
        
        var value = minValue
        // draw line (from center to out)
        for i in 0..<numberOfValue {
            if i == numberOfValue-1 {
                angle = model.maxAngle
                value = maxValue
            }
            let label = makeLabel(length: length)
            label.textColor = valueLabelTextColor
            label.text = decimalFormat.formattedValue(value)
            label.font = model.adjustFont(rect: label.frame)
            meterView.addSubview(label)
            label.center = CGPoint(x: meterCenter.x + smallRadius * CGFloat(cosf(angle)),
                                   y: meterCenter.y + smallRadius * CGFloat(sinf(angle)))
            angle += model.angleUnit
            value += model.valueUnit
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
        
        var angle = model.minAngle
        let smallRadius = radius - (radius/10 + meterBorderLineWidth)
        let path = UIBezierPath()
        
        // draw line (from center to out)
        for i in 0..<numberOfValue {
            if i == numberOfValue-1 {
                angle = model.maxAngle
            }
            let start = CGPoint(x: meterCenter.x + radius * CGFloat(cosf(angle)),
                                y: meterCenter.y + radius * CGFloat(sinf(angle)))
            path.move(to: start)
            let end = CGPoint(x: meterCenter.x + smallRadius * CGFloat(cosf(angle)),
                              y: meterCenter.y + smallRadius * CGFloat(sinf(angle)))
            path.addLine(to: end)
            angle += model.angleUnit
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
        valueHandLayer.path = makeHandPath(angle: model.minAngle).cgPath
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
                valueHandLayer.path = self.makeHandPath(angle: self.model.endAngle).cgPath
                CATransaction.commit()
            }
        }
       
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fillMode = .forwards
        rotationAnimation.toValue = model.endAngle - model.startAngle
        rotationAnimation.duration = 0.2
        rotationAnimation.isRemovedOnCompletion = false
        model.startAngle = model.endAngle
        valueHandLayer.add(rotationAnimation, forKey: "rotateAnimation")
        CATransaction.commit()
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
