//
//  GameOverScene.swift
//  Gesture_Recognizers
//
//  Created by Jonathan Green on 8/14/15.
//  Copyright (c) 2015 Jonathan Green. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
   
    override init(size: CGSize) {
        super.init(size: size)
        
        
        self.backgroundColor = SKColor.whiteColor()
        
        
        let message = "Game over"
        
        
        var label = SKLabelNode(fontNamed: "Arial Hebrew")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(label)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
