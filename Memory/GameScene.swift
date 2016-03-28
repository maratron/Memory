//
//  GameScene.swift
//  Memory
//
//  Created by Nico Hämäläinen on 28/03/16.
//  Copyright (c) 2016 sizeof.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    let deck = Deck(
      name: "Animals",
      cardNames: [
        "Dog",
        "Cat",
        "Squirrel",
        "Horse",
        "Parrot",
        "Ferret",
        "Pig",
        "Cow",
        "Snake",
        "Lion",
        "Giraffe",
        "Human"
      ]
    )
    
    let board = Board(deck: deck)
    print(board)
  }
}
