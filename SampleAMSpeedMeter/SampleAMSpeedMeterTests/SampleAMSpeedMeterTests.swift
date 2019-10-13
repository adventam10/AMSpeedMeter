//
//  SampleAMSpeedMeterTests.swift
//  SampleAMSpeedMeterTests
//
//  Created by am10 on 2019/10/13.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SampleAMSpeedMeter

class SampleAMSpeedMeterTests: XCTestCase {
    
    private let angle180 = Float(Double.pi)
    private let angle360 = Float(Double.pi*2)
    private let accuracy: Float = 0.00001
    private var angleHalf: Float {
        return angle180 + (angle360 - angle180)/2
    }
    
    private var angleQuarter: Float {
        return angle180 + (angle360 - angle180)/4
    }
    
    private var angleThreeQuarters: Float {
        return angle180 + ((angle360 - angle180)/4)*3
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAngleUnit() {
        let model = AMSpeedMeterModel()
        model.numberOfValue = 2
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/1, accuracy: accuracy)
        model.numberOfValue = 3
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/2, accuracy: accuracy)
        model.numberOfValue = 4
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/3, accuracy: accuracy)
        model.numberOfValue = 5
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/4, accuracy: accuracy)
        model.numberOfValue = 6
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/5, accuracy: accuracy)
        model.numberOfValue = 7
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/6, accuracy: accuracy)
        model.numberOfValue = 8
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/7, accuracy: accuracy)
        model.numberOfValue = 9
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/8, accuracy: accuracy)
        model.numberOfValue = 10
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/9, accuracy: accuracy)
        model.numberOfValue = 100
        XCTAssertEqual(model.angleUnit, (angle360 - angle180)/99, accuracy: accuracy)
    }

    func testValueUnit() {
        let model = AMSpeedMeterModel()
        var minValue: CGFloat = 0
        var maxValue: CGFloat = 100
        model.minValue = minValue
        model.maxValue = maxValue
        model.numberOfValue = 2
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/1, accuracy: CGFloat(accuracy))
        model.numberOfValue = 3
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/2, accuracy: CGFloat(accuracy))
        model.numberOfValue = 4
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/3, accuracy: CGFloat(accuracy))
        model.numberOfValue = 5
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/4, accuracy: CGFloat(accuracy))
        model.numberOfValue = 6
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/5, accuracy: CGFloat(accuracy))
        model.numberOfValue = 7
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/6, accuracy: CGFloat(accuracy))
        model.numberOfValue = 8
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/7, accuracy: CGFloat(accuracy))
        model.numberOfValue = 9
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/8, accuracy: CGFloat(accuracy))
        model.numberOfValue = 10
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/9, accuracy: CGFloat(accuracy))
        model.numberOfValue = 100
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/99, accuracy: CGFloat(accuracy))
        
        minValue = -200
        maxValue = -100
        model.minValue = minValue
        model.maxValue = maxValue
        model.numberOfValue = 2
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/1, accuracy: CGFloat(accuracy))
        model.numberOfValue = 3
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/2, accuracy: CGFloat(accuracy))
        model.numberOfValue = 4
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/3, accuracy: CGFloat(accuracy))
        model.numberOfValue = 5
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/4, accuracy: CGFloat(accuracy))
        model.numberOfValue = 6
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/5, accuracy: CGFloat(accuracy))
        model.numberOfValue = 7
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/6, accuracy: CGFloat(accuracy))
        model.numberOfValue = 8
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/7, accuracy: CGFloat(accuracy))
        model.numberOfValue = 9
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/8, accuracy: CGFloat(accuracy))
        model.numberOfValue = 10
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/9, accuracy: CGFloat(accuracy))
        model.numberOfValue = 100
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/99, accuracy: CGFloat(accuracy))
        
        minValue = -2000
        maxValue = 1500
        model.minValue = minValue
        model.maxValue = maxValue
        model.numberOfValue = 2
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/1, accuracy: CGFloat(accuracy))
        model.numberOfValue = 3
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/2, accuracy: CGFloat(accuracy))
        model.numberOfValue = 4
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/3, accuracy: CGFloat(accuracy))
        model.numberOfValue = 5
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/4, accuracy: CGFloat(accuracy))
        model.numberOfValue = 6
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/5, accuracy: CGFloat(accuracy))
        model.numberOfValue = 7
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/6, accuracy: CGFloat(accuracy))
        model.numberOfValue = 8
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/7, accuracy: CGFloat(accuracy))
        model.numberOfValue = 9
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/8, accuracy: CGFloat(accuracy))
        model.numberOfValue = 10
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/9, accuracy: CGFloat(accuracy))
        model.numberOfValue = 100
        XCTAssertEqual(model.valueUnit, (maxValue - minValue)/99, accuracy: CGFloat(accuracy))
    }
    
    func testCalculateAngleWithValueMethod() {
        let model = AMSpeedMeterModel()
        model.numberOfValue = 10
        var minValue: CGFloat = 0
        var maxValue: CGFloat = 100
        model.minValue = minValue
        model.maxValue = maxValue
        XCTAssertEqual(model.calculateAngle(value: minValue), angle180, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 25), angleQuarter, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 50), angleHalf, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 75), angleThreeQuarters, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: maxValue), angle360, accuracy: accuracy)
        
        minValue = 100
        maxValue = 200
        model.minValue = minValue
        model.maxValue = maxValue
        XCTAssertEqual(model.calculateAngle(value: minValue), angle180, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 125), angleQuarter, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 150), angleHalf, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 175), angleThreeQuarters, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: maxValue), angle360, accuracy: accuracy)
        
        minValue = -200
        maxValue = -100
        model.minValue = minValue
        model.maxValue = maxValue
        XCTAssertEqual(model.calculateAngle(value: minValue), angle180, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: -175), angleQuarter, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: -150), angleHalf, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: -125), angleThreeQuarters, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: maxValue), angle360, accuracy: accuracy)
        
        minValue = -200
        maxValue = 200
        model.minValue = minValue
        model.maxValue = maxValue
        XCTAssertEqual(model.calculateAngle(value: minValue), angle180, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: -100), angleQuarter, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 0), angleHalf, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: 100), angleThreeQuarters, accuracy: accuracy)
        XCTAssertEqual(model.calculateAngle(value: maxValue), angle360, accuracy: accuracy)
    }
}
