# [![CircularRevealKit](./Art/CircularRevealKit.png)](#)

[![CI Status](https://app.bitrise.io/app/7bb98f99ce35b4e8.svg?token=vd860qvOkKynwpA0I19wDg)](https://www.bitrise.io/app/7bb98f99ce35b4e8#/builds)
[![Version](https://img.shields.io/cocoapods/v/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![License](https://img.shields.io/cocoapods/l/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![Platform](https://img.shields.io/cocoapods/p/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)

A lightweight library that brings Material Design's circular reveal effect to iOS. Present and dismiss view controllers or animate individual views with an expanding or contracting circular mask — written entirely in Swift 5.

## Preview

![GIF sample](https://media.giphy.com/media/3cwSEnIK1GJEs/giphy.gif)

## Features

- Circular reveal and unreveal transitions for `UIViewController`
- Works with both **navigation controller** (push/pop) and **modal** (present/dismiss) flows
- Circular mask animation on any `UIView`
- Optional fade color overlay between transitions
- Configurable duration, start frame, and delay
- **async/await** support alongside closure-based API
- **ProMotion** support — 120fps animations on capable devices (iOS 15+)
- Dark Mode compatible (`UIColor.systemBackground`)
- Zero third-party dependencies

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 14+

## Installation

### Swift Package Manager (recommended)

Add CircularRevealKit to your project via **File > Add Package Dependencies** in Xcode, using the repository URL:

```
https://github.com/T-Pro/CircularRevealKit.git
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/T-Pro/CircularRevealKit.git", from: "0.9.6")
]
```

### CocoaPods

Add the following to your `Podfile`:

```ruby
platform :ios, '13.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'CircularRevealKit', '~> 0.9.6'
end
```

Then run:

```bash
pod install
```

## Usage

Import the library:

```swift
import CircularRevealKit
```

### Present a View Controller

```swift
let detailVC = DetailViewController()
radialPresent(viewController: detailVC)
```

With options:

```swift
radialPresent(
    viewController: detailVC,
    duration: 0.5,
    startFrame: buttonFrame,
    fadeColor: .blue,
    delay: 0.1
) {
    print("Transition complete")
}
```

### Dismiss a View Controller

```swift
radialDismiss()
```

With options:

```swift
radialDismiss(fadeColor: .blue, delay: 0.5) {
    print("Dismissed")
}
```

### Animate a View Directly

Apply a circular mask animation to any `UIView`:

```swift
view.drawAnimatedCircularMask(
    startFrame: originRect,
    duration: 0.4,
    revealType: .reveal
) {
    print("Animation finished")
}
```

### async/await

All public methods are also available as async alternatives:

```swift
await radialPresent(viewController: detailVC, fadeColor: .blue)
// Continues only after the animation completes

await radialDismiss()
```

### ProMotion (120fps)

CircularRevealKit automatically requests high frame rates on ProMotion displays (iOS 15+). To enable 120fps in your app, add this key to your `Info.plist`:

```xml
<key>CADisableMinimumFrameDurationOnPhone</key>
<true/>
```

> **Note:** This key is required on iPhone. iPad Pro enables 120fps by default.

## Example

To run the example project, clone the repo and run `pod install` from the `Example` directory:

```bash
git clone https://github.com/T-Pro/CircularRevealKit.git
cd CircularRevealKit/Example
pod install
open CircularRevealKit.xcworkspace
```

## Author

Pedro Paulo de Amorim

## Acknowledgments

Based on [RadialTransition_swift](https://github.com/apadalko/RadialTransition_swift) by apadalko.

## License

CircularRevealKit is available under the MIT license. See the [LICENSE](LICENSE) file for details.
