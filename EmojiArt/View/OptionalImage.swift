//
//  SwiftUIView.swift
//  EmojiArt
//
//  Created by Ivan on 21/06/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
  
  var image: UIImage?
  
  var body: some View {
    Group {
      if image != nil {
        Image(uiImage: image!)
      }
    }
  }
}
