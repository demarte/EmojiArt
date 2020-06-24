//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Ivan De Martino on 6/20/20.
//  Copyright © 2020 Ivan De Martino. All rights reserved.
//

import SwiftUI
import Combine

final class EmojiArtDocument: ObservableObject {
  
  @Published private var emojiArt: EmojiArt
  @Published private(set) var backgroundImage: UIImage?
  private var autosaveCancellable: AnyCancellable?
  
  var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
  
  private static let untitled = "EmojiArtDocument.Untitled"
  
  init() {
    emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
    autosaveCancellable = $emojiArt.sink { emojiArt in
      UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
    }
    fetchBackgroundImageData()
  }
  
  //MARK: - Intents -
  
  func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
    emojiArt.addEmoji(text: emoji, size: Int(size), x: Int(location.x), y: Int(location.y))
  }
  
  func removeEmoji(_ emoji: EmojiArt.Emoji) {
    emojiArt.removeEmoji(emoji)
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
  
  var backgroundURL: URL? {
    get {
      emojiArt.backgroundURL
    }
    set {
      emojiArt.backgroundURL = newValue?.imageURL
      fetchBackgroundImageData()
    }
  }
  
  // MARK: - Fetch Image -
  
  private var fetchImageCancellable: AnyCancellable?
  
  private func fetchBackgroundImageData() {
    backgroundImage = nil
    if let url = self.emojiArt.backgroundURL {
      fetchImageCancellable?.cancel()
      fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
        .map { data, urlResponse in UIImage(data: data) }
        .receive(on: DispatchQueue.main)
        .replaceError(with: nil)
        .assign(to: \.backgroundImage, on: self)
    }
  }
}

// MARK: - Model extension -

extension EmojiArt.Emoji {
  var fontSize: CGFloat { CGFloat(self.size) }
  var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
