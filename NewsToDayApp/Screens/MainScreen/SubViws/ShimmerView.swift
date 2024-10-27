//
//  ShimmerView.swift
//  NewsToDayApp
//
//  Created by Marat Fakhrizhanov on 26.10.2024.
//

import SwiftUI

// https://github.com/markiv/SwiftUI-Shimmer/blob/main/README.md // about shimming

public struct Shimmer: ViewModifier {
    public enum Mode {
        case mask
        case overlay(blendMode: BlendMode = .sourceAtop)
        case background
    }

    private let animation: Animation
    private let gradient: Gradient
    private let min, max: CGFloat
    private let mode: Mode
    @State private var isInitialState = true
    @Environment(\.layoutDirection) private var layoutDirection

    public init(
        animation: Animation = Self.defaultAnimation,
        gradient: Gradient = Self.defaultGradient,
        bandSize: CGFloat = 0.3,
        mode: Mode = .mask
    ) {
        self.animation = animation
               self.gradient = gradient
               self.min = 0 - bandSize
               self.max = 1 + bandSize
               self.mode = mode
           }

           public static let defaultAnimation = Animation.linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false)

           public static let defaultGradient = Gradient(colors: [
               .black.opacity(0.3),
               .black,
               .black.opacity(0.3)
           ])
    var startPoint: UnitPoint {
            if layoutDirection == .rightToLeft {
                isInitialState ? UnitPoint(x: max, y: min) : UnitPoint(x: 0, y: 1)
            } else {
                isInitialState ? UnitPoint(x: min, y: min) : UnitPoint(x: 1, y: 1)
            }
        }

        var endPoint: UnitPoint {
            if layoutDirection == .rightToLeft {
                isInitialState ? UnitPoint(x: 1, y: 0) : UnitPoint(x: min, y: max)
            } else {
                isInitialState ? UnitPoint(x: 0, y: 0) : UnitPoint(x: max, y: max)
            }
        }

        public func body(content: Content) -> some View {
            applyingGradient(to: content)
                .animation(animation, value: isInitialState)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        isInitialState = false
                    }
                }
        }
    @ViewBuilder public func applyingGradient(to content: Content) -> some View {
           let gradient = LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
           switch mode {
           case .mask:
               content.mask(gradient)
           case let .overlay(blendMode: blendMode):
               content.overlay(gradient.blendMode(blendMode))
           case .background:
               content.background(gradient)
           }
       }
   }

   public extension View {
       @ViewBuilder func shimmering(
           active: Bool = true,
           animation: Animation = Shimmer.defaultAnimation,
           gradient: Gradient = Shimmer.defaultGradient,
           bandSize: CGFloat = 0.3,
           mode: Shimmer.Mode = .mask
       ) -> some View {
              if active {
                  modifier(Shimmer(animation: animation, gradient: gradient, bandSize: bandSize, mode: mode))
              } else {
                  self
              }
          }

          @available(*, deprecated, message: "Use shimmering(active:animation:gradient:bandSize:) instead.")
          @ViewBuilder func shimmering(
              active: Bool = true, duration: Double, bounce: Bool = false, delay: Double = 0.25
          ) -> some View {
              shimmering(
                  active: active,
                  animation: .linear(duration: duration).delay(delay).repeatForever(autoreverses: bounce)
              )
          }
      }

struct ShimmerView: View {
    
    let cef: Double
    
    var body: some View {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 256/cef, height: 256/cef)
                        .foregroundStyle(DS.Colors.grayLight)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 240/cef, height: 240/cef)
                        .foregroundStyle(DS.Colors.grayLighter)
                        .shimmering()
                    
                    Text(Resources.Text.news.uppercased())
                        .font(.interSemiBold(20))
                        .foregroundStyle(DS.Colors.purplePrimary)
                        .shimmering()
                }
    }
}

#Preview {
    ShimmerView(cef: 1)
}
