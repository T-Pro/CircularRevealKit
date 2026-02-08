# CircularRevealKit - Project Overview

## Summary

**CircularRevealKit** is an iOS library written in Swift 5 that brings Android's Material Design circular reveal animation to iOS. It provides a simple API for presenting and dismissing `UIViewController` instances (and masking `UIView` instances) with an expanding/contracting circular animation, similar to `ViewAnimationUtils.createCircularReveal()` on Android.

- **Version**: 0.9.6
- **License**: MIT
- **Author**: Pedro Paulo de Amorim (T-Pro)
- **Minimum iOS**: 9.0
- **Language**: Swift 5 (with Swift 4.2 compatibility noted)
- **Size**: ~40 KB

## Purpose

On Android, the circular reveal is a first-class animation primitive provided by the framework. iOS has no built-in equivalent. CircularRevealKit fills this gap by leveraging `CAShapeLayer` masking and `CABasicAnimation` on the `path` key-path to produce a smooth elliptical reveal/unreveal effect.

## Distribution

The library supports three distribution methods:

| Method | Configuration File |
|---|---|
| **CocoaPods** | `CircularRevealKit.podspec` |
| **Carthage** | Carthage-compatible via the Git repo |
| **Swift Package Manager** | `Package.swift` (swift-tools-version 5.3) |

## Repository Structure

```
CircularRevealKit/
├── Art/                          # Banner image
├── CircularRevealKit/
│   ├── Assets/                   # Empty asset catalog placeholder
│   └── Classes/                  # Library source (6 Swift files)
│       ├── CicularTransactionDirector.swift
│       ├── DefaultCircularAnimation.swift
│       ├── LayerAnimator.swift
│       ├── RevealType.swift
│       ├── UICircularViewControllerExtension.swift
│       └── UIViewRadial.swift
├── Example/                      # Demo app with CocoaPods workspace
│   ├── CircularRevealKit/        # Example app source
│   ├── Pods/                     # CocoaPods dependencies
│   └── Tests/                    # Test target (currently empty)
├── CircularRevealKit.podspec     # CocoaPods spec
├── Package.swift                 # SPM manifest
├── LICENSE                       # MIT license
└── README.md                     # User-facing documentation
```

## Key Features

1. **Reveal presentation** -- circular expanding mask to present a new view controller.
2. **Unreveal dismissal** -- circular contracting mask to dismiss the current view controller.
3. **Configurable origin** -- the animation can start from any `CGRect` (defaults to screen center).
4. **Configurable duration** -- default 0.5 seconds, fully customizable.
5. **Fade color overlay** -- optional color overlay that fades in/out during the transition.
6. **Delay support** -- optional delay before the animation begins.
7. **UIView-level API** -- `drawAnimatedCircularMask` can be used directly on any `UIView`.
8. **UINavigationController support** -- works with both modal presentation and navigation push/pop via `UIViewControllerAnimatedTransitioning`.
