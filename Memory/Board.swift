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
    self.createTiles()
  }
  
  func createTiles() {
    self.tiles = Array(count: rows, repeatedValue: Array(count: cols, repeatedValue: Tile.empty))

    var cardPairs = deck.cards.reduce([], combine: { $0 + [$1, $1] })
    
    for row in 0 ..< rows {
      for col in 0 ..< cols {
        guard let card = cardPairs.popLast() else {
          fatalError("Unable to get card when creating grid")
        }
        
        self.tiles[row][col] = Tile(card: card, col: col, row: row)
      }
    }
  }
  
  subscript(row: Int, column: Int) -> Tile {
    get {
      return self.tiles[row][column]
    }
  }
}

// MARK: - CustomStringConvertible

extension Board: CustomStringConvertible {
  var description: String {
    return tiles.map { $0.map { "\($0)" }.joinWithSeparator(", ") }.joinWithSeparator("\n")
  }
}