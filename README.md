# AMSpeedMeter

![Pod Platform](https://img.shields.io/cocoapods/p/AMSpeedMeter.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMSpeedMeter.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMSpeedMeter.svg?style=flat)](http://cocoapods.org/pods/AMSpeedMeter)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

`AMSpeedMeter` is a view can display the value at regular time intervals.

## Demo

![speedmeter](https://user-images.githubusercontent.com/34936885/34904032-a3c3f6da-f880-11e7-99ea-094d83a89e14.gif)

## Usage

```swift
// property
private var speedMeterView: AMSpeedMeterView!
private var timer: Timer?

override func viewDidLoad() {
  super.viewDidLoad()

  speedMeterView = AMSpeedMeterView(frame: view.bounds)
  view.addSubview(speedMeterView)

  // customize here

  timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                               selector: #selector(self.timerAction(teimer:)),
                               userInfo: nil, repeats: true)
}

/// Timer Action
@objc func timerAction(teimer: Timer) {
  /// set CGFloat value
  speedMeterView.currentValue = value
}
```

### Customization
`AMSpeedMeter` can be customized via the following properties.

```swift
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
public var valueLabelFont: UIFont = .systemFont(ofSize: 15)
public var decimalFormat: AMSMDecimalFormat = .none
public var currentValue: CGFloat = 0.0
```

![speed](https://user-images.githubusercontent.com/34936885/66710713-e435b080-edb8-11e9-8107-9c6bacc8f8ae.png)

## Installation

### CocoaPods

Add this to your Podfile.

```ogdl
pod 'AMSpeedMeter'
```

### Carthage

Add this to your Cartfile.

```ogdl
github "adventam10/AMSpeedMeter"
```

## License

MIT
