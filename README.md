# [![CircularRevealKit](./Art/CircularRevealKit.png)](#)

[![CI Status](https://www.bitrise.io/app/7bb98f99ce35b4e8.svg?token=vd860qvOkKynwpA0I19wDg)](https://www.bitrise.io/app/7bb98f99ce35b4e8#/builds)
[![Version](https://img.shields.io/cocoapods/v/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![License](https://img.shields.io/cocoapods/l/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![Platform](https://img.shields.io/cocoapods/p/CircularRevealKit.svg?style=flat)](http://cocoapods.org/pods/CircularRevealKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)

This library was created to allow developers to implement the material design's reveal effect.
You can simply use this component to reveal and unvereal a ViewController/View, this component is very small (approx. 40kb), written purely in Swift 5 with support of Swift 4.2.

## Sample
![GIF sample](https://media.giphy.com/media/3cwSEnIK1GJEs/giphy.gif)

## Requirements

Swift 4 and iOS 9+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate CircularRevealKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
pod 'CircularRevealKit', '~> 0.9'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate CircularRevealKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "T-Pro/CircularRevealKit" ~> 0.9
```

Run `carthage update` to build the framework and drag the built `CircularRevealKit.framework` into your Xcode project.

## How to

You can simply import the library using `import CircularRevealKit`, then:

##### Please assert if your root ViewController is a instance of `UINavigationViewController`, otherwise the library will throw a error message.

To push your view controller, use:

```swift
radialPresent(viewController: viewController)
```

or 

```swift
radialPresent(viewController: viewController, duration, startFrame, revealType, completionBlock?)
```

To close it:

```swift
radialDismiss()
```

To use with view:

```swift
view.drawAnimatedCircularMask(startFrame, duration, revealType, completionBlock?)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Pedro Paulo de Amorim

## Based on:

* [RadialTransition_swift][1]

## License

CircularRevealKit is available under the MIT license. See the LICENSE file for more info.

[1]: https://github.com/apadalko/RadialTransition_swift
