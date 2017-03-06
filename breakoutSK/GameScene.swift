//
//  GameScene.swift
//  breakoutSK
//
//  Created by teacher on 3/5/17.
//  Copyright © 2017 Mathien. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate //add this to use physics
{
    var ball : SKSpriteNode!
    var paddle : SKSpriteNode!
    var brick : SKSpriteNode!

    var brickHit = 0
    
    override func didMove(to view: SKView) //the viewDidLoad of spritekit
    {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //make edge of view part of physics

        createBackground()
        makePaddle()
        makeBall()
        makeBrick()
        loseZone()

        // this should go in start button when created
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) //step 6 move paddle
    {
        /* Called when a touch begins */
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) //step 6 move paddle
    {
        /* Called when a touch moves */
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }

    func didBegin(_ contact: SKPhysicsContact) //step 7 contact function
    {
        //check for specific contact w/ brick
        if contact.bodyA.node?.name == "brick" || contact.bodyB.node?.name == "brick"
        {
            print("brick hit")
            brickHit += 1

            if brickHit == 3
            {
                // removes brick from view
                brick.removeFromParent()
            }
        }

        //check for specific contact w/ loseZone
        else if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("u lose")
        }

    }

    func makeBall() //step 2
    {
        let ballDiameter = frame.width/20
        ball = SKSpriteNode(color: UIColor.green, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.name = "ball"

        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody?.isDynamic = false //ignores all forces and impulses
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!

        addChild(ball) //adds to superview
    }

    func makePaddle() //step 3
    {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"

        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false

        addChild(paddle)
    }

    func makeBrick() // step 4
    {
        brick = SKSpriteNode(color: UIColor.blue, size: CGSize(width: frame.width/5, height: frame.height/25))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        brick.name = "brick"

        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false

        addChild(brick)
    }

    func loseZone() //step 5
    {
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"

        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false

        addChild(loseZone)
    }

    func createBackground() //step 1 create scrolling backgorund
    {
        let stars = SKTexture(imageNamed: "stars")

        for i in 0 ... 1  //creates 2 of the same image for seamless transisiton

        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1 // sets stacking order
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5)// sets anchor image
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height * CGFloat(i) - CGFloat(1 * i)))

            addChild(starsBackground)

            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            starsBackground.run(moveForever)
        }
    }
}
