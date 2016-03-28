//
//  Deck.swift
//  Memory
//
//  Created by Nico Hämäläinen on 28/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import GameplayKit

class Deck {
  /// List of cards belonging to this deck
  var cards: [Card] = []
  
  /// Name of the deck
  let name: String
  
  /// Create a new Deck
  ///
  /// - parameter name: The name of the deck
  ///
  /// - returns: The newly created deck
  init(name: String) {
    self.name = name
  }
  
  /// Create a new Deck with predefined card objects
  ///
  /// - parameter name: The name of the deck
  /// - parameter cards: The cards in this deck
  ///
  /// - returns: The newly created deck
  convenience init(name: String, cards: [Card]) {
    self.init(name: name)
    self.cards = cards
  }
  
  /// Create a new Deck with just the names of the cards
  ///
  /// - parameter name: The name of the deck
  /// - parameter cardNames: The names of the cards in this deck
  ///
  /// - returns: The newly created deck
  convenience init(name: String, cardNames: [String]) {
    self.init(name: name, cards: cardNames.map({ Card(name: $0) }))
  }
}

// MARK: Manipulation

extension Deck {
  /// Shuffle the cards in this deck using the fisher-yates algorithm
  func shuffleCards() {
    guard cards.count >= 2 else { return }
    
    // For each card in the deck
    for index in 0 ..< cards.count - 1 {
      // Generate a random int between the remaining count of the array after
      // looping through the indexes.
      let newIndex = Int(arc4random_uniform(UInt32(cards.count - index))) + index
      
      // Make sure it's not the same as the current one or we'll leave it
      guard index != newIndex else { continue }
      
      // Swap the cards in the cards array
      swap(&cards[index], &cards[newIndex])
    }
  }
}

/// MARK: - CustomStringConvertible

extension Deck: CustomStringConvertible {
  /// String representation of this deck
  var description: String {
    return "\(name): \(cards.map({$0.description}).joinWithSeparator(", "))"
  }
}