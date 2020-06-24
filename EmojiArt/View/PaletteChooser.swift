//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Ivan De Martino on 6/24/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {

  @ObservedObject var document: EmojiArtDocument

  @Binding var choosePalette: String

  var body: some View {
    HStack {
      Stepper(onIncrement: {
        self.choosePalette = self.document.palette(after: self.choosePalette)
      }, onDecrement: {
        self.choosePalette = self.document.palette(before: self.choosePalette)
      }, label: { EmptyView() })
      Text(self.document.paletteNames[self.choosePalette] ?? "")
    }
    .fixedSize(horizontal: true, vertical: true)
  }
}

struct PaletteChooser_Previews: PreviewProvider {
  static var previews: some View {
    PaletteChooser(document: EmojiArtDocument(), choosePalette: .constant(""))
  }
}
