//
//  Deck.swift
//  Memory
//
//  Created by Nico Hämäläinen on 28/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation

/// Represents a deck of cards used in the memory game
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
    
    // Count the number of rows we need by getting the square root of the double count
    let rows = floor(sqrt(Double(cards.count * 2)))
    
    // Count the number of cols we need by dividing the double count with the number of rows
    let cols = ceil(Double(cards.count * 2) / rows)
    
    guard Int(rows * cols) == cards.count * 2 else {
      fatalError("Given deck size is invalid, cannot produce an uniform grid size")
    }
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

/// MARK: - CustomStringConvertible

extension Deck: CustomStringConvertible {
  /// String representation of this deck
  var description: String {
    return "\(name): \(cards.map { "\($0)" }.joinWithSeparator(", "))"
  }
}