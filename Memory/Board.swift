//
//  Board.swift
//  Memory
//
//  Created by Nico Hämäläinen on 29/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import GameplayKit

class Board {
  let deck: Deck
  let size: Int
  var tiles: [[Tile]] = []
  
  var rows: Int {
    return Int(sqrt(Double(deck.cards.count * 2)))
  }
  
  var cols: Int {
    return Int(ceil(Double(deck.cards.count * 2) / Double(rows)))
  }
  
  init(deck: Deck) {
    self.deck = deck
    self.size = deck.cards.count
  }
  
  func resetAndShuffleTiles() {
    self.tiles = Array(count: rows, repeatedValue: Array(count: cols, repeatedValue: Tile.empty))

    var cardPairs = deck.cards.reduce([], combine: { $0 + [$1, $1] })
    cardPairs.shuffleInPlace()
    
    for row in 0 ..< rows {
      for col in 0 ..< cols {
        guard let card = cardPairs.popLast() else {
          fatalError("Unable to get card when creating grid")
        }
        
        self.tiles[row][col] = Tile(card: card, col: col, row: row)
      }
    }
  }
}

// MARK: - Game logic

extension Board {
  /// Shorthand subscript accessor for board[row,column] style tile get
  ///
  /// - parameter row: The row to access
  /// - parameter col: The column to access
  ///
  /// - returns: The Tile found, or nil
  subscript(row: Int, column: Int) -> Tile? {
    get {
      if row >= rows || column >= cols { return nil }
      
      return self.tiles[row][column]
    }
  }
  
  /// Check if the board has matching tiles (cards) in two points
  func hasMatchingTilesAt(rowOne rowOne: Int, colOne: Int, rowTwo: Int, colTwo: Int) -> Bool {
    guard let tileOne = self[rowOne, colOne], tileTwo = self[rowOne, colOne] else {
      return false
    }
    
    return tileOne.card == tileTwo.card
  }
}

// MARK: - CustomStringConvertible

extension Board: CustomStringConvertible {
  var description: String {
    return tiles.map { $0.map { "\($0)" }.joinWithSeparator(", ") }.joinWithSeparator("\n")
  }
}