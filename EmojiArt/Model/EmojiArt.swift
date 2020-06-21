//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Ivan De Martino on 6/20/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import Foundation

struct EmojiArt {

  var backgroundURL: URL?
  var emojis = [Emoji]()

  struct Emoji: Identifiable {
    let text: String
    var size: Int
    var x: Int
    var y: Int
    var id: Int

    fileprivate init(text: String, size: Int, x: Int, y: Int, id: Int) {
      self.text = text
      self.size = size
      self.x = x
      self.y = y
      self.id = id
    }
  }

  private var uniqueEmojiId = 0

  mutating func addEmoji(text: String, size: Int, x: Int, y: Int) {
    uniqueEmojiId += 1
    emojis.append(Emoji(text: text, size: size, x: x, y: y, id: uniqueEmojiId))
  }
}
