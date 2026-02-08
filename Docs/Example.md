# CircularRevealKit - Example App

## Overview

The example app is a simple two-screen iOS application that demonstrates both the `radialPresent` and `radialDismiss` APIs. It is distributed as a CocoaPods workspace.

## Running the Example

```bash
cd Example
pod install
open CircularRevealKit.xcworkspace
```

Build and run on an iOS simulator or device.

## App Structure

### `AppDelegate.swift`

Standard app delegate that creates a `UIWindow` with a `UINavigationController` wrapping `FirstViewController` as the root. The navigation bar is hidden.

```
UIWindow
  └── UINavigationController (nav bar hidden)
        └── FirstViewController
```

### `FirstViewController.swift`

The main screen. It displays a `UITableView` with two cells and a full-screen "stub view" that performs an unreveal animation on launch (splash screen effect).

**Key behaviors:**
- On launch, a black overlay (`stubView`) with a centered logo (`logoView`) covers the screen. It unreveals with `drawAnimatedCircularMask` to reveal the table beneath.
- Tapping the first cell calls `radialPresent` to show `SecondViewController` with a blue fade overlay and a 0.5-second delay.
- Tapping the second cell presents `SecondViewController` with the standard iOS modal animation (for comparison).

**Table cells:**
| Row | Image | Tap Action |
|---|---|---|
| 0 | `view_controller` (full color) | Circular reveal present |
| 1 | `view_cell` (dimmed, with "Not ready" label) | Standard modal present |

### `FirstViewControllerContraints.swift`

An extension on `FirstViewController` containing the Auto Layout constraint setup for `tableView`, `stubView`, and `logoView`. Uses the legacy `NSLayoutConstraint` initializer.

### `SecondViewController.swift`

The presented screen. It shows:
- A `UINavigationBar` at the top with title "SecondViewController".
- A centered `UIButton` labeled "Click me".
- A green `UIView` bar at the bottom (44pt tall).

Tapping "Click me" calls `radialDismiss(fadeColor: UIColor.blue, delay: 0.5)` to dismiss with a circular unreveal animation.

### `CircularViewCell.swift`

A custom `UITableViewCell` with:
- A `cardImageView` (rounded corners, 8pt margin from cell edges).
- A `titleLabel` centered in the cell (shown only for disabled cells).

The `loadImage(named:disabled:)` method dims the image and shows the label for disabled cells.

### `UIImageViewExtension.swift`

A helper extension on `UIImageView` that provides `roundCornersForAspectFit(radius:)`. This calculates the actual drawing rect based on the image's aspect ratio and applies a rounded bezier path mask.

## Animation Flow Demo

```
┌─────────────────────────┐
│   FirstViewController   │
│  ┌───────────────────┐  │
│  │  view_controller  │──── tap ──→ radialPresent(fadeColor: .blue)
│  │  (full color)     │  │                │
│  ├───────────────────┤  │                ▼
│  │  view_cell        │  │    ┌─────────────────────────┐
│  │  (dimmed + label) │  │    │  SecondViewController   │
│  └───────────────────┘  │    │                         │
│                         │    │   [ Click me ] ─── tap ──→ radialDismiss(fadeColor: .blue)
│                         │    │                         │          │
│                         │◀───┼─────────────────────────┘          │
│                         │    circular unreveal ◀──────────────────┘
└─────────────────────────┘
```

## Asset Catalog

The example app includes the following image assets in `Images.xcassets`:

| Asset | Description |
|---|---|
| `AppIcon` | Full set of app icons (20pt through 83.5pt, all scales) |
| `lib_icon` | Library logo displayed on the splash stub view |
| `view_cell` | Thumbnail for the second table cell |
| `view_controller` | Thumbnail for the first table cell |

## Test Target

The example includes a `Tests` target with an `Info.plist`, but the `Tests.swift` file is empty. No unit or UI tests are currently implemented.
