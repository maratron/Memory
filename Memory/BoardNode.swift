//
//  BoardNode.swift
//  Memory
//
//  Created by Nico Hämäläinen on 29/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import SpriteKit

/// The visual representation of a game board
class BoardNode: SKSpriteNode {
  /// The Board data model to render
  var board: Board
  
  /// All the TileNodes living in this BoardNode
  var tileNodes: [TileNode] = []
  
  /// Currently selected tile nodes
  var selectedTilePair: [TileNode] = []
  
  /// Total match tries
  var totalTries: Int = 0
  
  /// Creates a new BoardNode
  ///
  /// - parameter board: The board data model to use
  /// - parameter size: The maximum size of the board (used to calculate tile size)
  ///
  /// - returns: The newly created BoardNode
  init(board: Board, size: CGSize) {
    self.board = board
    super.init(texture: nil, color: .whiteColor(), size: size)
    
    userInteractionEnabled = true
    
    self.resetTileNodes()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func resetTileNodes() {
    // Reset tile nodes array
    tileNodes.forEach({ $0.removeFromParent(); })
    tileNodes = []
    selectedTilePair = []
    
    // Calculate optimal tile size
    let tileSize = CGSize(width: size.width / CGFloat(board.cols), height: size.height / CGFloat(board.rows))
    
    // Create tile nodes
    for row in 0 ..< board.rows {
      for col in 0  ..< board.cols {
        guard let tile = board[row, col] else {
          fatalError("Could not create TileNode in BoardNode: Tile \(row)x\(col) wasn't found")
        }

        let tileNode = TileNode(tile: tile, size: tileSize)
        tileNode.name = tile.card.name.lowercaseString
        addChild(tileNode)
        tileNodes.append(tileNode)
      }
    }
    
    layoutTileNodes()
  }
  
  func layoutTileNodes() {
    // Calculate optimal tile size
    let tileSize = CGSize(width: size.width / CGFloat(board.cols), height: size.height / CGFloat(board.rows))
    for row in 0 ..< board.rows {
      for col in 0  ..< board.cols {
        guard let tileNode = tileNodes.filter({ $0.tile.row == row && $0.tile.col == col }).first else {
          fatalError("Could not create TileNode in BoardNode: Tile \(row)x\(col) wasn't found")
        }
        
        let adjustedPositionX = (CGFloat(col) * tileSize.width) + (tileSize.width / 2)
        let adjustedPositionY = (CGFloat(row) * tileSize.height) + (tileSize.height / 2)
        
        let tilePosition = CGPoint(x: adjustedPositionX, y: adjustedPositionY)
        tileNode.position = tilePosition
        tileNode.resize(tileSize)
      }
    }
  }
  
  override func mouseUp(theEvent: NSEvent) {
    let location = theEvent.locationInNode(self)
    
    tileNodes.filter({ $0.state != .Revealed || $0.state != .Matched }).forEach { node in
      if node.containsPoint(location) {
        node.state = .Revealed
        selectedTilePair.append(node)
        
        if self.selectedTilePair.count == 2 {
          totalTries = totalTries + 1
          self.performSelector(#selector(checkForAndHandleMatch), withObject: nil, afterDelay: 0.3)
        }
      }
    }
  }
  
  func checkForAndHandleMatch() {
    self.userInteractionEnabled = false
    
    guard let one = selectedTilePair.first, two = selectedTilePair.last else {
      return
    }
    
    if two.tile.card == one.tile.card {
      one.state = .Matched
      two.state = .Matched
    }
    else {
      let flashRedSequence = SKAction.sequence([
        SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.5, duration: 0.15),
        SKAction.colorizeWithColor(one.contentNode.color, colorBlendFactor: 0.5, duration: 0.15),
      ])
      let rotateSequence = SKAction.sequence([
        SKAction.moveByX(-10, y: 0.0, duration: 0.1),
        SKAction.moveByX(20, y: 0.0, duration: 0.1),
        SKAction.moveByX(-10, y: 0.0, duration: 0.1),
      ])
      
      one.contentNode.runAction(flashRedSequence)
      two.contentNode.runAction(flashRedSequence)
      one.cropNode.runAction(rotateSequence)
      two.cropNode.runAction(rotateSequence)
    }
    
    self.selectedTilePair = []
    
    if self.tileNodes.filter({ $0.state != .Matched }).count > 0 {
      self.performSelector(#selector(resetRevealedTiles), withObject: nil, afterDelay: 0.6)
    }
    else {
      // Finished!
      let alert = NSAlert()
      alert.messageText = "Congratulations!"
      alert.informativeText = "You won the game in just 5 tries!"
      alert.addButtonWithTitle("Play Again")
      alert.addButtonWithTitle("Quit Game")
      
      // Play again
      let result = alert.runModal()
      switch result {
      case NSAlertFirstButtonReturn:
        self.resetTileNodes()
      case NSAlertSecondButtonReturn:
        NSApplication.sharedApplication().terminate(nil)
      default:
        break
      }
    }
  }
  
  func resetRevealedTiles() {
    tileNodes.filter({ $0.state != .Matched }).forEach { node in
      node.state = .Hidden
    }
    self.userInteractionEnabled = true
  }
}

extension BoardNode {
  func alertDidEnd(alert: NSAlert, returnCode: NSInteger, contextInfo: UnsafePointer<Void>) {
    
  }
}