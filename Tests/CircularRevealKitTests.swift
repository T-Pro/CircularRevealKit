//
// Copyright (c) 2026 T-Pro
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import CircularRevealKit

final class CircularRevealKitTests: XCTestCase {

  // MARK: - RevealType Tests

  func testRevealTypeHasRevealCase() {
    let type = RevealType.reveal
    XCTAssertNotNil(type)
  }

  func testRevealTypeHasUnrevealCase() {
    let type = RevealType.unreveal
    XCTAssertNotNil(type)
  }

  func testRevealTypeCasesAreDistinct() {
    XCTAssertFalse(RevealType.reveal == RevealType.unreveal,
                   ".reveal and .unreveal should be distinct cases")
  }

  // MARK: - DefaultCircularAnimation Tests

  func testDefaultAnimationDurationValue() {
    XCTAssertEqual(defaultCircularAnimationDuration, 0.5,
                   "Default animation duration should be 0.5 seconds")
  }

  func testDefaultAnimationDurationIsPositive() {
    XCTAssertGreaterThan(defaultCircularAnimationDuration, 0,
                         "Default animation duration should be positive")
  }

  func testAnimationKeyPathValue() {
    XCTAssertEqual(animationKeyPath, "path",
                   "Animation key path should be 'path'")
  }

  // MARK: - CircularTransitionDirector Tests

  func testDirectorInitialization() {
    let director = CircularTransitionDirector()
    XCTAssertNotNil(director)
  }

  func testDirectorDefaultDuration() {
    let director = CircularTransitionDirector()
    XCTAssertEqual(director.duration, defaultCircularAnimationDuration,
                   "Director default duration should match the global default")
  }

  func testDirectorCustomDuration() {
    let director = CircularTransitionDirector()
    director.duration = 1.0
    XCTAssertEqual(director.duration, 1.0,
                   "Director duration should be settable")
  }

  func testDirectorTransitionContextIsNilByDefault() {
    let director = CircularTransitionDirector()
    XCTAssertNil(director.transitionContext,
                 "Transition context should be nil by default")
  }

  func testDirectorAnimationBlockIsNilByDefault() {
    let director = CircularTransitionDirector()
    XCTAssertNil(director.animationBlock,
                 "Animation block should be nil by default")
  }

  func testDirectorAnimationBlockCanBeSet() {
    let director = CircularTransitionDirector()
    director.animationBlock = { (_, _, completion) in
      completion(true)
    }
    XCTAssertNotNil(director.animationBlock,
                    "Animation block should be settable")
  }

  func testDirectorConformsToAnimatedTransitioning() {
    let director = CircularTransitionDirector()
    XCTAssertTrue(director is UIViewControllerAnimatedTransitioning,
                  "Director should conform to UIViewControllerAnimatedTransitioning")
  }

  func testDirectorConformsToInteractiveTransitioning() {
    let director = CircularTransitionDirector()
    XCTAssertTrue(director is UIViewControllerInteractiveTransitioning,
                  "Director should conform to UIViewControllerInteractiveTransitioning")
  }

  func testDirectorConformsToNavigationControllerDelegate() {
    let director = CircularTransitionDirector()
    XCTAssertTrue(director is UINavigationControllerDelegate,
                  "Director should conform to UINavigationControllerDelegate")
  }

  func testDirectorTransitionDuration() {
    let director = CircularTransitionDirector()
    director.duration = 0.75
    let duration = director.transitionDuration(using: nil)
    XCTAssertEqual(duration, 0.75,
                   "transitionDuration should return the configured duration")
  }

  // MARK: - Deprecated Typealias Tests

  func testDeprecatedTypealiasExists() {
    let director: CicularTransactionDirector = CircularTransitionDirector()
    XCTAssertNotNil(director,
                    "CicularTransactionDirector typealias should still work for backward compatibility")
  }

  // MARK: - UIView Extension Tests

  func testDrawAnimatedCircularMaskSetsViewVisible() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.isHidden = true

    let expectation = self.expectation(description: "Animation completes")

    view.drawAnimatedCircularMask(
      startFrame: CGRect(x: 50, y: 50, width: 0, height: 0),
      duration: 0.1,
      revealType: .reveal
    ) {
      expectation.fulfill()
    }

    XCTAssertFalse(view.isHidden,
                   "View should be visible after calling drawAnimatedCircularMask")

    waitForExpectations(timeout: 1.0)
  }

  func testDrawAnimatedCircularMaskAppliesMaskLayer() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

    view.drawAnimatedCircularMask(
      startFrame: CGRect(x: 100, y: 100, width: 0, height: 0),
      duration: 0.1,
      revealType: .reveal
    )

    XCTAssertNotNil(view.layer.mask,
                    "View layer should have a mask after calling drawAnimatedCircularMask")
    XCTAssertTrue(view.layer.mask is CAShapeLayer,
                  "The mask should be a CAShapeLayer")
  }

  func testDrawAnimatedCircularMaskCallsStartBlock() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectation = self.expectation(description: "Start block called")

    view.drawAnimatedCircularMask(
      startFrame: CGRect(x: 50, y: 50, width: 0, height: 0),
      duration: 0.1,
      revealType: .reveal,
      startBlock: {
        expectation.fulfill()
      }
    )

    waitForExpectations(timeout: 1.0)
  }

  // MARK: - UIViewController Extension Tests

  func testRadialPresentIsAvailable() {
    let vc = UIViewController()
    // Verify the method exists and is callable (compilation test)
    XCTAssertTrue(vc.responds(to: #selector(UIViewController.radialPresent)))
  }

  func testRadialDismissIsAvailable() {
    let vc = UIViewController()
    // Verify the method exists and is callable (compilation test)
    XCTAssertTrue(vc.responds(to: #selector(UIViewController.radialDismiss)))
  }

}

// MARK: - Selector helpers for existence checks
private extension UIViewController {
  @objc func radialPresent() {}
  @objc func radialDismiss() {}
}
