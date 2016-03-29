//
//  AppDelegate.swift
//  Memory
//
//  Created by Nico Hämäläinen on 28/03/16.
//  Copyright (c) 2016 sizeof.io. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var skView: SKView!
  
  var skScene: SKScene?
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    window!.delegate = self
    
    skView!.ignoresSiblingOrder = true
    skView!.showsFPS = true
    skView!.showsNodeCount = true
    
    skScene = GameScene(size: skView!.frame.size)
    skScene!.scaleMode = .AspectFit
    skView!.presentScene(skScene!)
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
    return true
  }
}

extension AppDelegate: NSWindowDelegate {
  func windowDidResize(notification: NSNotification) {
    skScene?.size = skView.frame.size
  }
}