//
//  Card.swift
//  Memory
//
//  Created by Nico Hämäläinen on 28/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation

/// Represents a card that belongs to a deck
class Card {
  /// Name of the card
  let name: String
  
  /// Create a new card with a given name
  ///
  /// - parameter name: Name of the card
  ///
  /// - returns: The newly created card
  init(name: String) {
    self.name = name
  }
  
  static let empty = Card(name: "")
}

// MARK: - CustomStringConvertible

extension Card: CustomStringConvertible {
  /// String representation of this card
  var description: String {
    return self.name
  }
}

// MARK: - Equatable

extension Card: Equatable { }
func == (lhs: Card, rhs: Card) -> Bool {
  return lhs.name == rhs.name
}