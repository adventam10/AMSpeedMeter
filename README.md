# AMSpeedMeterView

`AMSpeedMeterView` is a view can display the value at regular time intervals.

## Demo

![speedmeter](https://user-images.githubusercontent.com/34936885/34904032-a3c3f6da-f880-11e7-99ea-094d83a89e14.gif)

## Variety

<img width="333" alt="speedmeter" src="https://user-images.githubusercontent.com/34936885/34904069-f9042ad4-f880-11e7-89ab-21122cf9afd9.png">

## Usage

```swift
// property
private let speedMeterView = AMSpeedMeterView()
private var timer:Timer?

override func viewDidLoad() {
super.viewDidLoad()

// customize here

view.addSubview(speedMeterView)
timer = Timer.scheduledTimer(timeInterval: 0.5,
target: self,
selector: #selector(self.timerAction(teimer:)),
userInfo: nil,
repeats: true)
}

/// Timer Action
@objc func timerAction(teimer:Timer) {

/// set CGFloat value
speedMeterView.currentValue = value
}
```

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
