//
//  GameScene.swift
//  Paper Plane Game
//
//  Created by Justin Kobler on 7/25/17.
//  Copyright © 2017 Justin Kobler Apps. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Plane : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Bird : UInt32 = 0x1 << 4
    static let Score : UInt32 = 0x1 << 5
    static let TopBound : UInt32 = 0x1 << 6

}

var showAd = false

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playCount = Int()
    
    var TopBound = SKSpriteNode()
    var Ground = SKSpriteNode()
    var Plane = SKSpriteNode()
    
    var wallPair = SKNode()
    var Bird = SKSpriteNode()
    /*var Airplane = SKSpriteNode()
    var Cloud = SKSpriteNode()
    var Tree = SKSpriteNode()*/
    
    var moveAndRemoveWalls = SKAction()
    var moveAndRemoveWalls2 = SKAction()
    var moveAndRemoveWalls3 = SKAction()
    var moveAndRemoveWalls4 = SKAction()
    var moveAndRemoveWalls5 = SKAction()
    var moveAndRemoveWalls6 = SKAction()

    var moveAndRemoveBirds = SKAction()
    var moveAndRemoveBirds2 = SKAction()
    
    var gameStarted = Bool()
    var died = Bool()
    var restartBTN = SKSpriteNode()
    
    var score = Int()
    let scoreLbl = SKLabelNode()
    var highScore = Int()
    let highScoreLbl = SKLabelNode()
    var startGameLbl = SKLabelNode()
    
    func willAdShow() -> Bool {
        if gameStarted == false {
            return true
        }
        else {
            return false
        }
    }
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene() {
        //showAd = true
        self.physicsWorld.contactDelegate = self
        
        
        highScoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5 + 10)
        highScoreLbl.text = "High Score: \(highScore)"
        highScoreLbl.fontName = "Georgia"
        highScoreLbl.fontSize = 24
        highScoreLbl.zPosition = 12
        highScoreLbl.fontColor = SKColor.black
        self.addChild(highScoreLbl)
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: highScoreLbl.position.y - 50)
        scoreLbl.text = "Score: \(score)"
        scoreLbl.fontName = "Georgia"
        scoreLbl.fontSize = 36
        scoreLbl.zPosition = 10
        scoreLbl.fontColor = SKColor.black
        self.addChild(scoreLbl)
        
        TopBound = SKSpriteNode()
        TopBound.size = CGSize(width: self.frame.width, height: 1)
        TopBound.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        TopBound.physicsBody = SKPhysicsBody(rectangleOf: TopBound.size)
        TopBound.physicsBody?.categoryBitMask = PhysicsCategory.TopBound
        TopBound.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        TopBound.physicsBody?.contactTestBitMask = 0
        TopBound.physicsBody?.affectedByGravity = false
        TopBound.physicsBody?.isDynamic = false
        self.addChild(TopBound)
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(1.0)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        Ground.zPosition = 4
        Ground.name = "Ground"
        Ground.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ground"), size: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        self.addChild(Ground)
        
        
        Plane = SKSpriteNode(imageNamed: "Paper Plane")
        Plane.size = CGSize(width: 60, height: 35)
        Plane.position = CGPoint(x: self.frame.width / 2 - Plane.frame.width, y: self.frame.height / 2)
        Plane.zPosition = 3
        Plane.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        Plane.physicsBody?.categoryBitMask = PhysicsCategory.Plane
        Plane.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Bird | PhysicsCategory.TopBound
        Plane.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score | PhysicsCategory.Bird
        Plane.physicsBody?.affectedByGravity = false
        Plane.physicsBody?.isDynamic = true
        self.addChild(Plane)
        
        startGameLbl.position = CGPoint(x: self.frame.width / 2, y: Plane.position.y - 60)
        startGameLbl.text = "Touch Screen to Start"
        startGameLbl.fontName = "Arial"
        startGameLbl.fontSize = 24
        startGameLbl.zPosition = 15
        startGameLbl.fontColor = SKColor.gray
        startGameLbl.run(SKAction.scale(to: 1, duration: 0.3))
        self.addChild(startGameLbl)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        var highScoreDefault = UserDefaults.standard
        
        if (highScoreDefault.value(forKey: "highScore") != nil) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger!
            highScoreLbl.text = NSString(format: "High Score: \(highScore)" as NSString, highScore) as String
        }
        
        playCount = 1
        createScene()
        
    }
    
    func createBTN() {
        //showAd = true
        restartBTN = SKSpriteNode(imageNamed: "Restart Button")
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 11
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.5))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Plane || firstBody.categoryBitMask == PhysicsCategory.Plane && secondBody.categoryBitMask == PhysicsCategory.Score {
            
            score += 1
            scoreLbl.text = "Score: \(score)"
            
            if score > highScore {
                highScore = score
                highScoreLbl.text = "High Score: \(highScore)"
                
                var highScoreDefault = UserDefaults.standard
                highScoreDefault.setValue(highScore, forKey: "highScore")
                highScoreDefault.synchronize()
                
            }
            
        }
        
        else if firstBody.categoryBitMask == PhysicsCategory.Plane && secondBody.categoryBitMask == PhysicsCategory.Wall || firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Plane || firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Plane || firstBody.categoryBitMask == PhysicsCategory.Plane && secondBody.categoryBitMask == PhysicsCategory.Bird || firstBody.categoryBitMask == PhysicsCategory.Plane && secondBody.categoryBitMask == PhysicsCategory.Ground || firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Plane {
            
            showAd = true
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false {
                died = true
                print("showAd = \(showAd)")
                createBTN()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showAd = false
        if gameStarted == false {
            

            gameStarted = true
            
            Plane.physicsBody?.affectedByGravity = true
            
            startGameLbl.run(SKAction.scale(to: 0, duration: 0.3))
            
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.wait(forDuration: 2.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let SpawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(SpawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let moveWalls = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.01 * distance))
            let moveWalls2 = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.009 * distance))
            let moveWalls3 = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let moveWalls4 = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.007 * distance))
            let moveWalls5 = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.006 * distance))
            let moveWalls6 = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.005 * distance))

            let rnd1 = Int(arc4random_uniform(5)) - 2
            let random1 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd1)
            let rnd2 = Int(arc4random_uniform(5)) - 2
            let random2 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd2)
            let rnd3 = Int(arc4random_uniform(5)) - 2
            let random3 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd3)
            let rnd4 = Int(arc4random_uniform(5)) - 2
            let random4 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd4)
            let rnd5 = Int(arc4random_uniform(5)) - 2
            let random5 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd5)
            let moveBirds1 = SKAction.moveBy(x: -distance / 3, y: distance * random1 / 4, duration: TimeInterval(0.0015 * distance))
            let moveBirds2 = SKAction.moveBy(x: -distance / 3, y: distance * random2 / 4, duration: TimeInterval(0.0015 * distance))
            let moveBirds3 = SKAction.moveBy(x: -distance / 3 - 50, y: distance * random3 / 4, duration: TimeInterval(0.0015 * distance))
            let moveBirds4 = SKAction.moveBy(x: -distance / 5, y: distance * random1 / 3, duration: TimeInterval(0.0008 * distance))
            let moveBirds5 = SKAction.moveBy(x: -distance / 5, y: distance * random2 / 3, duration: TimeInterval(0.0008 * distance))
            let moveBirds6 = SKAction.moveBy(x: -distance / 5, y: distance * random3 / 3, duration: TimeInterval(0.0008 * distance))
            let moveBirds7 = SKAction.moveBy(x: -distance / 5, y: distance * random4 / 3, duration: TimeInterval(0.0008 * distance))
            let moveBirds8 = SKAction.moveBy(x: -distance / 5 - 50, y: distance * random5 / 3, duration: TimeInterval(0.0008 * distance))
            let removeEnemies = SKAction.removeFromParent()
            moveAndRemoveWalls = SKAction.sequence([moveWalls, removeEnemies])
            moveAndRemoveWalls2 = SKAction.sequence([moveWalls2, removeEnemies])
            moveAndRemoveWalls3 = SKAction.sequence([moveWalls3, removeEnemies])
            moveAndRemoveWalls4 = SKAction.sequence([moveWalls4, removeEnemies])
            moveAndRemoveWalls5 = SKAction.sequence([moveWalls5, removeEnemies])
            moveAndRemoveWalls6 = SKAction.sequence([moveWalls6, removeEnemies])

            moveAndRemoveBirds = SKAction.sequence([moveBirds1, moveBirds2, moveBirds3, removeEnemies])
            moveAndRemoveBirds2 = SKAction.sequence([moveBirds4, moveBirds5, moveBirds6, moveBirds7, moveBirds8, removeEnemies])
            
            
            Plane.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            Plane.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
        }
        else {
            if died == true {
                
            }
            
            else {
                Plane.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                Plane.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
                
                let distance = CGFloat(self.frame.width + wallPair.frame.width)
                let rnd1 = Int(arc4random_uniform(5)) - 2
                let random1 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd1)
                let rnd2 = Int(arc4random_uniform(5)) - 2
                let random2 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd2)
                let rnd3 = Int(arc4random_uniform(5)) - 2
                let random3 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd3)
                let rnd4 = Int(arc4random_uniform(5)) - 2
                let random4 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd4)
                let rnd5 = Int(arc4random_uniform(5)) - 2
                let random5 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd5)
                let moveBirds1 = SKAction.moveBy(x: -distance / 3, y: distance * random1 / 4, duration: TimeInterval(0.0015 * distance))
                let moveBirds2 = SKAction.moveBy(x: -distance / 3, y: distance * random2 / 4, duration: TimeInterval(0.0015 * distance))
                let moveBirds3 = SKAction.moveBy(x: -distance / 3 - 50, y: distance * random3 / 4, duration: TimeInterval(0.0015 * distance))
                let moveBirds4 = SKAction.moveBy(x: -distance / 5, y: distance * random1 / 3, duration: TimeInterval(0.0008 * distance))
                let moveBirds5 = SKAction.moveBy(x: -distance / 5, y: distance * random2 / 3, duration: TimeInterval(0.0008 * distance))
                let moveBirds6 = SKAction.moveBy(x: -distance / 5, y: distance * random3 / 3, duration: TimeInterval(0.0008 * distance))
                let moveBirds7 = SKAction.moveBy(x: -distance / 5, y: distance * random4 / 3, duration: TimeInterval(0.0008 * distance))
                let moveBirds8 = SKAction.moveBy(x: -distance / 5 - 50, y: distance * random5 / 3, duration: TimeInterval(0.0008 * distance))
                let removeEnemies = SKAction.removeFromParent()
                moveAndRemoveBirds = SKAction.sequence([moveBirds1, moveBirds2, moveBirds3, removeEnemies])
                moveAndRemoveBirds2 = SKAction.sequence([moveBirds4, moveBirds5, moveBirds6, moveBirds7, moveBirds8, removeEnemies])
            }
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if died == true {
                showAd = true
                if restartBTN.contains(location) {
                    restartScene()
                }
            }
        }
        
    }
    
    func createWalls() {
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 320)
        topWall.setScale(0.5)
        topWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Wall"), size: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        
        let topWall2 = SKSpriteNode(imageNamed: "Wall")
        topWall2.position = CGPoint(x: self.frame.width + 25, y: topWall.position.y + topWall2.frame.height)
        topWall2.setScale(0.5)
        topWall2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Wall"), size: topWall2.size)
        topWall2.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall2.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        topWall2.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        topWall2.physicsBody?.affectedByGravity = false
        topWall2.physicsBody?.isDynamic = false

        
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        bottomWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 360)
        bottomWall.setScale(0.5)
        bottomWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Wall"), size: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false
        
        let bottomWall2 = SKSpriteNode(imageNamed: "Wall")
        bottomWall2.position = CGPoint(x: self.frame.width + 25, y: bottomWall.position.y - bottomWall2.frame.height)
        bottomWall2.setScale(0.5)
        bottomWall2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Wall"), size: bottomWall2.size)
        bottomWall2.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottomWall2.physicsBody?.collisionBitMask = PhysicsCategory.Plane
        bottomWall2.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        bottomWall2.physicsBody?.affectedByGravity = false
        bottomWall2.physicsBody?.isDynamic = false
        
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.addChild(topWall2)
        wallPair.addChild(bottomWall2)
        wallPair.addChild(scoreNode)
        wallPair.zPosition = 2
        wallPair.name = "wallPair"
        
        var randomPosition = CGFloat.random(min: -150, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        Bird = SKSpriteNode(imageNamed: "Bird")
        Bird.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        Bird.zPosition = 2
        Bird.setScale(0.4)
        Bird.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Bird"), size: Bird.size)
        Bird.physicsBody?.categoryBitMask = PhysicsCategory.Bird
        Bird.physicsBody?.collisionBitMask = PhysicsCategory.Plane | PhysicsCategory.Ground
        Bird.physicsBody?.contactTestBitMask = PhysicsCategory.Plane
        Bird.physicsBody?.affectedByGravity = false
        Bird.physicsBody?.isDynamic = true
        
        var randomPosition2 = CGFloat.random(min: -50, max: 100)
        Bird.position.y = Bird.position.y + randomPosition2
        
        let enemyList = [wallPair, Bird]
        let random = Int(arc4random_uniform(2))
            
        if enemyList[random] == wallPair {
            if score < 10 {
                enemyList[random].run(moveAndRemoveWalls)
            }
            else if score < 20 && score >= 10 {
                enemyList[random].run(moveAndRemoveWalls2)
            }
            else if score < 30 && score >= 20 {
                enemyList[random].run(moveAndRemoveWalls3)
            }
            else if score < 40 && score >= 30 {
                enemyList[random].run(moveAndRemoveWalls4)
            }
            else if score < 50 && score >= 40 {
                enemyList[random].run(moveAndRemoveWalls5)
            }
            else {
                enemyList[random].run(moveAndRemoveWalls6)
            }
        }
        else {
            if score < 25 {
                enemyList[random].run(moveAndRemoveBirds)
            }
            else {
                enemyList[random].run(moveAndRemoveBirds2)
            }
        }
        self.addChild(enemyList[random])
        
    }
    
    /*func displayAd() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createAndLoadInterstitial"), object: nil)
    }
    
    func checkAd() {
        if playCount % 3 == 0 {
            displayAd()
        }
    }*/
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
}
