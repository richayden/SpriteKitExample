//
//  GameScene.swift
//  SpriteKitExample
//
//  Created by Bob Pascazio on 12/3/15.
//  Copyright (c) 2015 Pace. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        
        player.position = CGPoint(x: size.width*0.1, y: size.height*0.5)
        
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence(
                [SKAction.runBlock(addMonster), SKAction.waitForDuration(1)]
            ))
        )
        
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
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max:CGFloat) -> CGFloat {
        
        return random() * (max-min) + min
        
    }
    
    func addMonster() {
        
        let monster = SKSpriteNode(imageNamed: "monster")
        
        let actualy = random(monster.size.height/2, max:size.height-monster.size.height/2)
        
        monster.position = CGPoint(x:size.width + monster.size.width/2, y:actualy)
        
        addChild(monster)

        let actualDuration = random(CGFloat(2), max:CGFloat(5))
        
        let actionMove = SKAction.moveTo(CGPoint(x:-monster.size.width/2, y:actualy), duration:NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove,actionMoveDone]))
        
    }
    
    
}
