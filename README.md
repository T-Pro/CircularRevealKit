# [![CircularRevealKit](./Art/CircularRevealKit.png)](#)

[![CI Status](https://www.bitrise.io/app/7bb98f99ce35b4e8.svg?token=vd860qvOkKynwpA0I19wDg)](https://www.bitrise.io/app/7bb98f99ce35b4e8#/builds)
[![Version](https://img.shields.io/cocoapods/v/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![License](https://img.shields.io/cocoapods/l/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![Platform](https://img.shields.io/cocoapods/p/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
![Swift 3](https://img.shields.io/badge/Swift-3-orange.svg?style=flat)

This library was created to allow developers to implement the material design's reveal effect.
You can simply use this component to reveal and unvereal a ViewController/View, this component is very small (approx. 40kb), written purely in Swift 3.

## Sample
![GIF sample](https://media.giphy.com/media/3cwSEnIK1GJEs/giphy.gif)

## Requirements

Swift 3 and iOS 9+

## Installation

CircularRevealKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CircularRevealKit"
```

and run `pod install`.

## How to

You can simply import the library using `import CircularRevealKit`, then:

### Please assert if your root ViewController is a instance of `UINavigationViewController`, otherwise the library will throw a message.

To push your view controller, use:

```swift
radialPushViewController(viewController, duration, startFrame, revealType, completionBlock?)
```

To close it:

```swift
radialPopViewController()
```

To use with view:

```swift
view.drawAnimatedCircularMask(startFrame, duration, revealType, completionBlock?)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

T-Pro, engineer@tpro.ie

## Based on:

* [RadialTransition_swift][1]

## License

CircularRevealKit is available under the MIT license. See the LICENSE file for more info.

[1]: https://github.com/apadalko/RadialTransition_swift
