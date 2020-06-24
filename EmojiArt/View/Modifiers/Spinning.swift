//
//  Spinning.swift
//  EmojiArt
//
//  Created by Ivan De Martino on 6/24/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import SwiftUI

struct Spinning: ViewModifier {

  @State private var isVisible: Bool = false

  func body(content: Content) -> some View {
    content
      .rotationEffect(Angle.degrees(isVisible ? 360 : 0))
      .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
      .onAppear {
        self.isVisible = true
    }
  }
}

extension View {
  func spinning() -> some View {
    self.modifier(Spinning())
  }
}
