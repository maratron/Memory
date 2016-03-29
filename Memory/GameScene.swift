//
//  GameScene.swift
//  Memory
//
//  Created by Nico Hämäläinen on 28/03/16.
//  Copyright (c) 2016 sizeof.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  var boardNode: BoardNode?
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    backgroundColor = NSColor(red: 217/255, green: 203/255, blue: 158/255, alpha: 1.0)
    
    let deck = Deck(
      name: "Animals",
      cardNames: [
        "Dog",
        "Cat",
        "Cow",
        "Snake",
        "Lion",
        "Human"
      ]
    )
    
    // Create and shuffle board
    let board = Board(deck: deck)
    board.resetAndShuffleTiles()
    
    boardNode = BoardNode(board: board, size: view.frame.size)
    addChild(boardNode!)
  }
  
  override func didChangeSize(oldSize: CGSize) {
    super.didChangeSize(oldSize)
    
    boardNode?.size = size
    boardNode?.layoutTileNodes()
  }
}
