//
//  GameScene.swift
//  SpriteKitExample
//
//  Created by Bob Pascazio on 12/3/15.
//  Copyright (c) 2015 Pace. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All  : UInt32 = UInt32.max
    static let Monster : UInt32 = 0b0001
    static let Projectile : UInt32 = 0b0010
}

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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
        
        physicsWorld.gravity = CGVectorMake(0,0)
        physicsWorld.contactDelegate = self
        
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
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size)
        monster.physicsBody?.dynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
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
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
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
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        print("hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
    }
    
}
