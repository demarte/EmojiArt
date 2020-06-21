//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Ivan De Martino on 6/20/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import SwiftUI

final class EmojiArtDocument: ObservableObject {
  
  static let palette: String = "📺🔭🚪🪑🛋🛌🖥🪕"
  
  // @Published // workaround for property observer problem with property wrappers
  private var emojiArt: EmojiArt {
    willSet {
      objectWillChange.send()
    }
    didSet {
      UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
    }
  }
  @Published private(set) var backgroundImage: UIImage?
  
  var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
  
  private static let untitled = "EmojiArtDocument.Untitled"
  
  init() {
    emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
    fetchBackgroundImageData()
  }
  
  //MARK: - Intents -
  
  func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
    emojiArt.addEmoji(text: emoji, size: Int(size), x: Int(location.x), y: Int(location.y))
  }
  
  func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
    if let index = emojiArt.emojis.firstIndex(matching: emoji) {
      emojiArt.emojis[index].x += Int(offset.width)
      emojiArt.emojis[index].y += Int(offset.height)
    }
  }
  
  func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
    if let index = emojiArt.emojis.firstIndex(matching: emoji) {
      emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
    }
  }
  
  func setBackgroundURL(_ url: URL?) {
    emojiArt.backgroundURL = url?.imageURL
    fetchBackgroundImageData()
  }
  
  private func fetchBackgroundImageData() {
    backgroundImage = nil
    
    if let url = self.emojiArt.backgroundURL {
      DispatchQueue.global(qos: .userInitiated).async {
        if let imageData = try? Data(contentsOf: url) {
          DispatchQueue.main.async {
            if url == self.emojiArt.backgroundURL {
              self.backgroundImage = UIImage(data: imageData)
            }
          }
        }
      }
    }
  }
}

extension EmojiArt.Emoji {
  var fontSize: CGFloat { CGFloat(self.size) }
  var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
