//
//  GameScene.swift
//  SpriteKitExample
//
//  Created by Bob Pascazio on 12/3/15.
//  Copyright (c) 2015 Pace. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right:CGPoint) -> CGPoint {
    
    return (CGPoint(x:left.x+right.x, y:left.y+right.y))
    
}

func - (left: CGPoint, right:CGPoint) -> CGPoint {
    
    return (CGPoint(x:left.x-right.x, y:left.y-right.y))
    
}

func * (left: CGPoint, scalar:CGFloat) -> CGPoint {
    
    return (CGPoint(x:left.x*scalar, y:left.y*scalar))
    
}

func / (left: CGPoint, scalar:CGFloat) -> CGPoint {
    
    return (CGPoint(x:left.x/scalar, y:left.y/scalar))
    
}

func sqrt(a:CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self/length()
    }
    
}

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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.position
        
        let offset = touchLocation - projectile.position
        if (offset.x<0) {return}
        
        addChild(projectile)
        
        let direction = offset.normalized()
        let shootAmount = direction * CGFloat(1000)
        
        let realDest = shootAmount + projectile.position
        
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove,actionMoveDone]))
        
    }
    
}
