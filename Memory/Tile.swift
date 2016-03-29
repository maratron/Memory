//
//  Tile.swift
//  Memory
//
//  Created by Nico Hämäläinen on 29/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation

class Tile {
  let card: Card
  let col: Int
  let row: Int
  let matched: Bool
  
  init(card: Card, col: Int, row: Int) {
    self.card = card
    self.col = col
    self.row = row
    self.matched = false
  }
  
  static let empty = Tile(card: Card.empty, col: 0, row: 0)
}

// MARK: - CustomStringConvertible

extension Tile: CustomStringConvertible {
  var description: String {
    return "\(row)x\(col): \(card)"
  }
}

// MARK: - Equatable

extension Tile: Equatable { }
func == (lhs: Tile, rhs: Tile) -> Bool {
  return lhs.card == rhs.card && lhs.col == rhs.col && lhs.row == rhs.row
}