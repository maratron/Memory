//
//  TileNode.swift
//  Memory
//
//  Created by Nico Hämäläinen on 29/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import SpriteKit

enum TileNodeState {
  case Hidden
  case Revealed
  case Matched
}

/// Represents a single tile visible on the board
class TileNode: SKSpriteNode {
  /// The Tile data model to render
  var tile: Tile
  
  /// The current state of the node
  var state: TileNodeState = .Hidden {
    didSet {
      self.animateStateChange(oldValue)
    }
  }
  
  /// The mask node that helps in shaping the tile node
  var maskNode: SKShapeNode!
  
  /// The crop node that helps in shaping the tile node
  var cropNode: SKCropNode!
  
  /// The content node to add everything into
  /// NOTE: This is the node that gets masked
  var contentNode: SKSpriteNode!
  
  /// The label node used to identify this tile node
  var labelNode: SKLabelNode!
  
  /// Creates a new TileNode
  ///
  /// - parameter tile: The Tile data model to render
  /// - parameter size: The size of the node
  ///
  /// - returns: The newly created TileNode
  init(tile: Tile, size: CGSize) {
    self.tile = tile
    super.init(texture: nil, color: .whiteColor(), size: size)
    
    createNodes()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createNodes() {
    // Create a content node to hold all other nodes
    contentNode = SKSpriteNode(texture: nil, color: SKColor(red: 55/255, green: 63/255, blue: 64/255, alpha: 1.0), size: frame.size)
    
    // Create label showing the value of the tile
    labelNode = SKLabelNode(text: self.tile.card.name)
    labelNode.verticalAlignmentMode = .Center
    labelNode.fontColor = .whiteColor()
    labelNode.fontSize = 18.0
    labelNode.fontName = "HelveticaNeue-Bold"
    labelNode.hidden = state == .Matched || state == .Revealed ? false : true
    contentNode.addChild(labelNode)
    
    // Create a mask node that we mask the content node with
    maskNode = SKShapeNode(rectOfSize: CGSize(width: frame.size.width - 10, height: frame.size.height - 10), cornerRadius: 4.0)
    maskNode.strokeColor = .clearColor()
    maskNode.fillColor = .whiteColor()
    
    // Create a crop node that crops the content node with the mask node
    cropNode = SKCropNode()
    cropNode.maskNode = maskNode
    cropNode.addChild(contentNode)
    addChild(cropNode)
    
    handleStateChange(nil)
  }
  
  func resize(newSize: CGSize) {
    size = newSize
    
    contentNode.size = size
    
    let tempNode = SKShapeNode(rectOfSize: CGSize(width: size.width - 10, height: size.height - 10), cornerRadius: 4.0)
    
    maskNode.path = tempNode.path
  }
  
  func handleStateChange(previousState: TileNodeState?) {
    switch state {
    case .Hidden:
      self.labelNode.hidden = true
    case .Revealed:
      self.labelNode.hidden = false
    case .Matched:
      self.labelNode.hidden = false
      self.contentNode.color = SKColor(red: 52/255, green: 220/255, blue: 112/255, alpha: 1.0)
    }
  }
  
  func animateStateChange(previousState: TileNodeState) {
    if previousState == state { return }
    
    let flipHide = SKAction.scaleXTo(0.0, duration: 0.15)
    let flipShow = SKAction.scaleXTo(1.0, duration: 0.15)
    
    setScale(1.0)
    
    switch state {
    case .Hidden:
      contentNode.runAction(flipHide) {
        self.handleStateChange(previousState)
        self.contentNode.runAction(flipShow)
      }
    case .Revealed:
      contentNode.runAction(flipHide) {
        self.handleStateChange(previousState)
        self.contentNode.runAction(flipShow)
      }
    case .Matched:
      self.runAction(SKAction.scaleTo(1.1, duration: 0.15)) {
        self.handleStateChange(previousState)
        self.runAction(SKAction.scaleTo(1.0, duration: 0.15))
      }
    }
  }
}