//
//  GameScene.swift
//  SpriteKitExample
//
//  Created by Bob Pascazio on 12/3/15.
//  Copyright (c) 2015 Pace. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            //sprite.runAction(SKAction.repeatActionForever(action))
            
            let actionMove = SKAction.moveTo(CGPoint(x:0, y:0), duration: NSTimeInterval(1))
            let actionMove2 = SKAction.moveTo(CGPoint(x:0, y:self.frame.height), duration: NSTimeInterval(1))
            let actionMoveDone = SKAction.removeFromParent()
            sprite.runAction(SKAction.sequence([actionMove,actionMove2,actionMoveDone]))
            
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
