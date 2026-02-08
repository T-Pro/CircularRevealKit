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

import SwiftUI
import CircularRevealKit

@available(iOS 15.0, *)
struct SwiftUIExampleView: View {

  @State private var showOverlay = false
  @State private var tapOrigin: CGPoint = .zero
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ZStack {
      // Background
      LinearGradient(
        colors: [.blue, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: 32) {

        Text("SwiftUI Circular Reveal")
          .font(.title2.bold())
          .foregroundColor(.white)

        Text("Tap the button to see the circular reveal effect")
          .font(.subheadline)
          .foregroundColor(.white.opacity(0.8))
          .multilineTextAlignment(.center)
          .padding(.horizontal, 40)

        // Reveal toggle button
        Button {
          showOverlay.toggle()
        } label: {
          Image(systemName: showOverlay ? "xmark.circle.fill" : "circle.fill")
            .font(.system(size: 64))
            .foregroundColor(.white)
            .shadow(radius: 8)
        }
        .background(
          GeometryReader { geometry in
            Color.clear
              .onAppear {
                let frame = geometry.frame(in: .global)
                tapOrigin = CGPoint(x: frame.midX, y: frame.midY)
              }
          }
        )

        // Dismiss button
        Button("Close") {
          dismiss()
        }
        .font(.headline)
        .foregroundColor(.white.opacity(0.7))
        .padding(.top, 20)

      }

      // Circular reveal overlay (always present, masked by shape)
      ZStack {
        Color.orange

        VStack(spacing: 24) {
          Image(systemName: "sparkles")
            .font(.system(size: 80))
            .foregroundColor(.white)

          Text("Revealed!")
            .font(.largeTitle.bold())
            .foregroundColor(.white)

          Text("Tap anywhere to dismiss")
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.8))
        }
        .opacity(showOverlay ? 1 : 0)
      }
      .ignoresSafeArea()
      .mask(
        CircularRevealShape(progress: showOverlay ? 1 : 0, origin: tapOrigin)
          .fill(Color.white)
          .ignoresSafeArea()
      )
      .allowsHitTesting(showOverlay)
      .onTapGesture {
        showOverlay = false
      }

    }
    .animation(.easeInOut(duration: 0.5), value: showOverlay)
  }

}
