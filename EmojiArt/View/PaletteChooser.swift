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

  @Binding var chosenPalette: String
  @State private var showPaletteEditor = false

  var body: some View {
    HStack {
      Stepper(onIncrement: {
        self.chosenPalette = self.document.palette(after: self.chosenPalette)
      }, onDecrement: {
        self.chosenPalette = self.document.palette(before: self.chosenPalette)
      }, label: { EmptyView() })
      Text(self.document.paletteNames[self.chosenPalette] ?? "")
      Image(systemName: "keyboard").imageScale(.large)
      .onTapGesture {
          self.showPaletteEditor = true
      }
      .popover(isPresented: $showPaletteEditor) {
          PaletteEditor(chosenPalette: self.$chosenPalette, isShowing: self.$showPaletteEditor)
              .environmentObject(self.document)
              .frame(minWidth: 300, minHeight: 500)
      }
    }
    .fixedSize(horizontal: true, vertical: true)
  }
}

struct PaletteChooser_Previews: PreviewProvider {
  static var previews: some View {
    PaletteChooser(document: EmojiArtDocument(), chosenPalette: .constant(""))
  }
}
