//
//  GameScene.swift
//  breakoutProject
//
//  Created by Brent Behling on 3/16/17.
//  Copyright © 2017 Brent Behling. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var brick = SKSpriteNode()
    var brickArray = [SKSpriteNode]()
    var brickCount = 0
    var count = 0
    var score = 0
    var removedBricks = 0
        
        
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        //createBackground()
        makeBall()
        makePaddle()
        placeBricks(numCols: 1)
        makeLoseZone()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        brickCount = brickArray.count
        for brick in brickArray {
            if contact.bodyA.node == brick || contact.bodyB.node == brick {
                score += 1
                
                if brick.color == UIColor.blue {
                    brick.color = UIColor.green
                }
                else if brick.color == UIColor.green {
                    brick.color = UIColor.purple
                }
            
            else if brick.color == UIColor.purple{
                brick.removeFromParent()
                removedBricks += 1
                if removedBricks == brickCount {
                    print("You Win")
                    }
                
                }
            }
            if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
            {
                print("You Lose!")
                ball.removeFromParent()
            }
        }
    }
 
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x:0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        ball.physicsBody?.isDynamic = false
        //use precise collisison detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) // add ball object to view
    }
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    func placeBricks(numCols: Int)  {
        count = 0
        while(count < numCols)    {
            if(count == 0)  {
                makeBrick(xPos: 0)
            }
            makeBrick(xPos: Int(frame.width)/5 + 5)
            makeBrick(xPos: -(Int(frame.width)/5 + 5))
            count += 1
        }
    }
    
    func makeBrick(xPos: Int) {
        brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/5, height: frame.height/25))
        brick.position = CGPoint(x: frame.midX + CGFloat(xPos), y: frame.maxY - 30)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
        brickArray.append(brick)
        
        
        /*var xPos = 10
         var yPos = 20
         
         let brickWidth = (Int)((frame.width - 60) / 5)
         let brickHeight = 20
         
         for rows in 1...3   {
         for columns in 1...5    {
         let brick = brick(frame: CGRect(x: xPos, y: yPos, width: brickWidth, height: brickHeight))
         brick.backgroundColor = UIColor.blue
         view?.addSubview(brick)
         
         brickArray.append(brick)
         brickCount += 1
         
         xPos += (brickWidth + 10)
         }
         }*/
    }
    
    func removeBrick() {
        
        
    }
    
    func makeLoseZone() {
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
}
