//
//  GameScene.swift
//  Gesture_Recognizers
//
//  Created by Jonathan Green on 8/4/15.
//  Copyright (c) 2015 Jonathan Green. All rights reserved.
//

import SpriteKit

enum BodyType:UInt32 {
    
    case Projectile = 1
    case monster = 2
    case player = 3
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myTimer:NSTimer?
    
    var restartbutton = UIButton();
    
    var score = 0
    
    var labelPoints = SKLabelNode(fontNamed: "Arial Hebrew")
  
   //Actions Varables
    var seq:SKAction?
    
    var repeat:SKAction?
    
    var followAction:SKAction?
    
    var reversePath:SKAction?
    
    var movingAnimation:SKAction?
    var movingExplosion:SKAction?
    //Actions Varables End
    
    //Sprite Varables
    var progress:Float = 100.00
    var HealthBar:SKSpriteNode?
    var ship = SKSpriteNode(imageNamed:"Ship")
    var target = SKSpriteNode(imageNamed:"target")
    var skull:SKSpriteNode?
    //Sprite Varables End
    
    //Sounds
    let SoundEffect:SKAction = SKAction.playSoundFileNamed("Hit.mp3", waitForCompletion: false)

    //Sounds End


    //Muiltipliers
    var offset:CGFloat = 0
    let length:CGFloat = 150
    var theRotation:CGFloat = 0
    //Muiltipliers
    
    //Gesture Varables
    let tapRect = UITapGestureRecognizer()
    let rotateRect = UIRotationGestureRecognizer()
    let swipeRightRect = UISwipeGestureRecognizer()
    let swipeLeftRect = UISwipeGestureRecognizer()
    let swipeUpRect = UISwipeGestureRecognizer()
    let swipeDownRect = UISwipeGestureRecognizer()
    let panRect = UIPanGestureRecognizer()
    let longPressRect = UILongPressGestureRecognizer()
    let pinchRect = UIPinchGestureRecognizer()
    //Gesture Varables End
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.addChild(labelPoints)
        explosion()
        //background
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPointMake((self.view!.bounds.width / 2), (self.view!.bounds.height / 2))
        bg.zPosition = -2

        addChild(bg)
        //background End
        
        //view.showsPhysics = true
        
        physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPointMake(0.0, 0.0)
        self.backgroundColor = SKColor.blackColor()
        
        let xOffset:CGFloat = 100
        
        //path that skulls follow
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, xOffset, self.view!.bounds.height - 20*3)
        
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 20*3)
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 50*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 50*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 80*3)
        
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 80*3)
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 110*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 110*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 140*3)
        
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 140*3)
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 170*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 170*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 200*3)
        
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 200*3)
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 230*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 230*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 260*3)
        
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 260*3)
        CGPathAddLineToPoint(path, nil, self.view!.bounds.width - xOffset, self.view!.bounds.height - 290*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 290*3)
        CGPathAddLineToPoint(path, nil, xOffset, self.view!.bounds.height - 310*3)
        
        
        followAction = SKAction.followPath(path, asOffset:false, orientToPath:true, duration:35.0)
        
        reversePath = followAction!.reversedAction()
        
        seq = SKAction.sequence([followAction!, reversePath!])
        
        repeat = SKAction.repeatActionForever(seq!)
        
        //skull!.runAction(repeat!)
        //skull path End
        
      ///uncomment to see lines for skull path
        //let line = SKShapeNode()
        //line.path = path
        //line.lineWidth = 1
        //line.fillColor = SKColor.blueColor()
        //line.strokeColor = SKColor.redColor()
        //self.addChild(line)
        
        //Create Countless More....
        
        let callFuncAction:SKAction = SKAction.runBlock { () -> Void in
            self.newSkull()
        }
        
        let wait:SKAction = SKAction.waitForDuration(0.5)
        let creationSeq:SKAction = SKAction.sequence([wait, callFuncAction])
        //let repeatCreation:SKAction = SKAction.repeatAction(creationSeq, count: 20)
        let repeatCreation:SKAction = SKAction.repeatActionForever(creationSeq)
        
        self.runAction(repeatCreation)
        
        
        //Skull End
        
        //handling Ship Sprite
        
        ship.physicsBody = SKPhysicsBody(texture: ship.texture, size: ship.size)
        ship.physicsBody?.dynamic = false
        ship.physicsBody?.categoryBitMask = BodyType.player.rawValue
        //ship.physicsBody?.collisionBitMask = BodyType.monster.rawValue
        ship.physicsBody?.collisionBitMask = 0
        ship.physicsBody?.contactTestBitMask = BodyType.monster.rawValue
        ship.physicsBody?.affectedByGravity = false
        ship.position = CGPointMake((self.view!.bounds.width / 2), (self.view!.bounds.height / 2) - 250)
        
        //ship.setScale(view.bounds.size.height/1000)
        //ship.setScale(view.bounds.size.width/1000)
        addChild(ship)
        
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector:"shoot", userInfo: nil, repeats: true)
        
        
        //Ship End
        
        //HealthBar
        HealthBar = SKSpriteNode(color:SKColor .yellowColor(), size: CGSize(width: CGFloat(progress), height: 30))
        HealthBar!.position = CGPointMake(ship.position.x - 50, ship.position.y - 100)
        HealthBar!.anchorPoint = CGPointMake(0.0, 0.5)
        //
        HealthBar!.zPosition = 4
        //HealthBar!.setScale(view.bounds.size.height/800)
        //HealthBar!.setScale(view.bounds.size.width/800)
        self.addChild(HealthBar!)
        //HealthBar End
        
        //Handles target Sprite
        addChild(target)
        
        target.position = CGPointMake(ship.position.x, ship.position.y + length)
        target.alpha = 0
        //target End
        
        setUpAnimation()
        explosion()
        
        
       //handels Gestures
        self.view!.multipleTouchEnabled = true
        self.view!.userInteractionEnabled = true
        
        tapRect.addTarget(self, action: "tappedView")
        tapRect.numberOfTapsRequired = 1
        tapRect.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(tapRect)
        
        rotateRect.addTarget(self, action: "rotateView:")
        self.view!.addGestureRecognizer(rotateRect)
        
        
        swipeRightRect.addTarget(self, action: "swipedRight")
        swipeRightRect.direction = .Right
        swipeRightRect.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(swipeRightRect)
        
        swipeLeftRect.addTarget(self, action: "swipedLeft")
        swipeLeftRect.direction = .Left
        swipeLeftRect.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(swipeLeftRect)
        
        swipeUpRect.addTarget(self, action: "swipedUp")
        swipeUpRect.direction = .Up
        swipeUpRect.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(swipeUpRect)

        swipeDownRect.addTarget(self, action: "swipedDown")
        swipeDownRect.direction = .Down
        swipeDownRect.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(swipeDownRect)
        
        panRect.addTarget(self, action: "panView:")
        panRect.minimumNumberOfTouches = 1
        panRect.maximumNumberOfTouches = 1
        self.view!.addGestureRecognizer(panRect)
        
        longPressRect.addTarget(self, action: "longPress")
        longPressRect.minimumPressDuration = 3
        longPressRect.allowableMovement = 100
        longPressRect.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(longPressRect)
        
        pinchRect.addTarget(self, action: "pinch:")
        //self.view!.addGestureRecognizer(pinchRect)
        
    }
    
    //functions for detecting contact
    func didBeginContact(contact: SKPhysicsContact) {
        var Body1 = contact.bodyA
        var Body2 = contact.bodyB
        
//this gets called automactically when to objects end contact with one another
        if (Body2.categoryBitMask == BodyType.monster.rawValue) && (Body1.categoryBitMask == BodyType.player.rawValue) {
            
            //the monster and the player made contact
            println("contact made")
            ship.runAction(SoundEffect)
            removeHealth()
            
            if Body2.node != nil {
                
                monsterHit(Body2.node as! SKSpriteNode)
            }
            
            
            if HealthBar!.size.width == 0 || HealthBar!.size.width < 0  {
                
                //let myTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("endGame"), userInfo: nil, repeats: false)
                endGame()
            }

        }
        
        
        if (Body1.categoryBitMask == BodyType.monster.rawValue) && (Body2.categoryBitMask == BodyType.Projectile.rawValue) || (Body2.categoryBitMask == BodyType.monster.rawValue) && (Body1.categoryBitMask == BodyType.Projectile.rawValue) {
            
            if (Body1.node != nil) && (Body2.node != nil) {
                
                bulletHit(Body1.node as! SKSpriteNode, Bullet: Body2.node as! SKSpriteNode)
            }
            
        }
        
    }
    
    func monsterHit(Monster:SKSpriteNode!) {
        
        if (Monster != nil) {
            
            Monster.removeFromParent()
            
        }

    }
    
    func bulletHit(Monster:SKSpriteNode!,Bullet:SKSpriteNode!){
        
        let message = "\(score)"
        
        
        
       
        if (Bullet != nil) && (Monster != nil) {
            
            score++
    
            labelPoints.text = message
            labelPoints.fontSize = 100
            labelPoints.fontColor = SKColor.blackColor()
            labelPoints.position = CGPointMake((self.size.width/2) - 300, (self.size.height/2) - 500)
            
            
           let SoundEffect:SKAction = SKAction.playSoundFileNamed("Explosion.mp3", waitForCompletion: false)
            let fireEnd = SKAction.removeFromParent()
            Monster.runAction(SoundEffect)
            Monster.runAction(SKAction.sequence([movingExplosion!,fireEnd]))
            Bullet.removeFromParent()
            
            winGame()
        }
       
    }

    
    func didEndContact(contact: SKPhysicsContact) {
        
        
    }
    //functions for detecting contact End
    
    
    //function that creates new Skulls
    func newSkull() {
        skull = SKSpriteNode(imageNamed: "skull")
        skull!.physicsBody = SKPhysicsBody(texture: skull!.texture, size: CGSizeMake(skull!.size.width - 10, skull!.size.height - 10))
        skull!.physicsBody?.dynamic = false
        skull!.physicsBody?.categoryBitMask = BodyType.monster.rawValue
        skull?.physicsBody?.contactTestBitMask = BodyType.Projectile.rawValue
        skull?.physicsBody?.affectedByGravity = false
        skull?.physicsBody?.dynamic = true
        skull!.position = CGPointMake(0,0)
        //skull!.setScale(view!.bounds.size.height/700)
        //skull!.setScale(view!.bounds.size.width/700)
        self.addChild(skull!)
        
        skull!.runAction(repeat!)
    }
    
    //explosion
    
    func explosion(){
        
        let atlas = SKTextureAtlas (named: "explosion")
        
        
        var array = [String]()
        
        for var i = 1; i <= 9; i++ {
            
            let nameString = String(format: "explosion%i",i)
            array.append(nameString)
            
        }
        
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++){
            
            let texture:SKTexture = atlas.textureNamed(array[i])
            atlasTextures.insert(texture, atIndex: i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/30, resize:true, restore:false)
        
        movingExplosion = SKAction.repeatAction(atlasAnimation, count: 2)
    }
    //explosion end
    //function that creates new Skulls End
    
    func shoot() {
        println("Boom")
        //Bullet
        var bullet1 = SKSpriteNode(imageNamed:"Bullet")
        bullet1.zPosition = -1
        bullet1.physicsBody = SKPhysicsBody(rectangleOfSize: bullet1.size)
        bullet1.physicsBody?.categoryBitMask = BodyType.Projectile.rawValue
        bullet1.physicsBody?.contactTestBitMask = BodyType.monster.rawValue
        bullet1.physicsBody?.affectedByGravity = false
        bullet1.physicsBody?.dynamic = false
        bullet1.physicsBody?.collisionBitMask = 0
        bullet1.position = CGPointMake(ship.position.x - 50
            , ship.position.y)
        
        var bullet2 = SKSpriteNode(imageNamed:"Bullet")
        bullet2.zPosition = -1
        bullet2.physicsBody = SKPhysicsBody(rectangleOfSize: bullet2.size)
        bullet2.physicsBody?.categoryBitMask = BodyType.Projectile.rawValue
        bullet2.physicsBody?.contactTestBitMask = BodyType.monster.rawValue
        bullet2.physicsBody?.affectedByGravity = false
        bullet2.physicsBody?.dynamic = false
        bullet2.physicsBody?.collisionBitMask = 0
        bullet2.position = CGPointMake(ship.position.x + 50
            , ship.position.y)
        
        let SoundEffect:SKAction = SKAction.playSoundFileNamed("SMG.mp3", waitForCompletion: false)
        
        let fire = SKAction.moveToY(self.size.height, duration: 1.0)
        let fireEnd = SKAction.removeFromParent()
        //bullet1.runAction(SoundEffect)
        //bullet2.runAction(SoundEffect)
        bullet1.runAction(SKAction.sequence([fire,fireEnd]))
        bullet2.runAction(SKAction.sequence([fire,fireEnd]))
        
        //bullet1.setScale(view!.bounds.size.height/800)
        //bullet1.setScale(view!.bounds.size.width/800)

      // bullet2.setScale(view!.bounds.size.height/800)
      // bullet2.setScale(view!.bounds.size.width/1000)

        self.addChild(bullet1)
        self.addChild(bullet2)
        //Bullet End
    }
    
    //removes skulls
    
    func winGame(){
        if labelPoints.text == "100" {
            
            self.removeAllChildren()
            self.removeAllActions()
            myTimer?.invalidate()
            
            self.backgroundColor = SKColor.whiteColor()
            let message = "You Win"
            var label = SKLabelNode(fontNamed: "Arial Hebrew")
            label.text = message
            label.fontSize = 40
            label.fontColor = SKColor.blackColor()
            label.position = CGPointMake(self.size.width/2, self.size.height/2)
            self.addChild(label)
            
            restartbutton.setTitle("Restart", forState: .Normal)
            restartbutton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            restartbutton.titleLabel!.font = UIFont.systemFontOfSize(40)
            restartbutton.frame = CGRectMake(280, 250, 200, 100)
            
            self.view!.addSubview(restartbutton)
            
            restartbutton.addTarget(self, action: "restart", forControlEvents: .TouchUpInside)
        }
    }
    func endGame(){
        self.removeAllChildren()
        self.removeAllActions()
        myTimer?.invalidate()
        
        self.backgroundColor = SKColor.whiteColor()
        let message = "Game over"
        var label = SKLabelNode(fontNamed: "Arial Hebrew")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(label)
        
        restartbutton.setTitle("Restart", forState: .Normal)
        restartbutton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        restartbutton.titleLabel!.font = UIFont.systemFontOfSize(40)
        restartbutton.frame = CGRectMake(280, 250, 200, 100)
        
        self.view!.addSubview(restartbutton)
        
        restartbutton.addTarget(self, action: "restart", forControlEvents: .TouchUpInside)

    }
    
    func restart() {
        self.removeAllChildren()
        self.removeAllActions()
        restartbutton.removeFromSuperview()
        var gameScene = GameScene(size: self.size)
        var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    //remove skulls end
    
    //reomoveHealth
    
    func removeHealth(){
        
        progress = progress - 10.0
        
        if progress >= 0 {
            
            HealthBar!.size = CGSize(width: CGFloat(progress), height: 30)
        }else{
            
            HealthBar!.size = CGSize(width: 0, height: 30)
        }
        
        
        println(progress)
    }

    //removeHealth End

    //handels Gestures functions
    func longPress(){
        
        println("longPressed")
    }
    
    func pinch(sender:UIPinchGestureRecognizer){
        
        ship.xScale = sender.scale
        ship.yScale = sender.scale
        
        println("Pinched velocity \(sender.velocity)")
    }
    
    func panView(sender:UIPanGestureRecognizer){
        
        println("pan")
        
        var touchLocation:CGPoint = sender.locationInView(self.view!)
        touchLocation = self.convertPointFromView(touchLocation)
        
        ship.position = touchLocation
        
        println("X \(touchLocation.x)")
        println("Y \(touchLocation.y)")
        
        if (sender.state == .Changed) {
        
            HealthBar!.position = CGPointMake(ship.position.x - 50, ship.position.y - 100)
            
            
        }
    }
    
    func swipedRight(){
        
        self.scene!.view!.paused = true;
        
        println("swiped Right")
        
        //ship.zRotation = CGFloat (DegreesToRadians(270))
        //offset = ship.zRotation
        //target.alpha = 0
       
        
    }
    
    func swipedLeft(){
        
        self.scene!.view!.paused = false;
        
        println("swiped Left")
        
        //ship.zRotation = CGFloat (DegreesToRadians(90))
        //offset = ship.zRotation
        //target.alpha = 0
    }
    
    func swipedUp(){
        
        //println("swiped Up")
        //ship.zRotation = CGFloat (DegreesToRadians(0))
        //offset = ship.zRotation
        //target.alpha = 0
        
    }
    
    func swipedDown(){
        
        //println("swiped Down")
        //ship.zRotation = CGFloat (DegreesToRadians(180))
        //offset = ship.zRotation
        //target.alpha = 0
        
    }
    
    
    func rotateView(sender:UIRotationGestureRecognizer){
        
        if (sender.state == .Began) {
            
            //do anything you want when the rotation gesture has begun
            
            let fade:SKAction = SKAction.fadeAlphaTo(1, duration: 0.5)
            target.runAction(fade)
            
            println("we done Started")
        }
        
        if (sender.state == .Changed) {
            
            //do anything you want when the rotation gesture has ended
            
            theRotation = CGFloat(sender.rotation) + self.offset
            theRotation = theRotation * -1
            
            ship.zRotation = theRotation
            target.zRotation = theRotation
            //HealthBar?.zPosition = theRotation
            
            let xDistance:CGFloat = sin(theRotation) * length
            let yDistance:CGFloat = cos(theRotation) * length
            
            target.position = CGPointMake(ship.position.x - xDistance, ship.position.y + yDistance)
            
            
            println("we done rotated")
        }
        
        if (sender.state == .Ended) {
            
            //do anything you want when the rotation gesture has ended
            
            self.offset = theRotation * -1
            
            println("we done Ended")
        }
        
    }
    
    func tappedView(){
        
        println("we done tapped")
        HealthBar!.position = CGPointMake(ship.position.x - 50, ship.position.y - 100)
        
        let fade:SKAction = SKAction.fadeAlphaTo(0, duration: 0.5)
        target.runAction(fade)
        
        let move:SKAction = SKAction.moveTo(target.position, duration: 0.6)
        move.timingMode = .EaseOut
        
        let moveX:SKAction = SKAction.moveToX(target.position.x - 50, duration: 0.6)
        moveX.timingMode = .EaseOut
        let moveY:SKAction = SKAction.moveToY(target.position.y - 100, duration: 0.6)
        moveY.timingMode = .EaseOut
        
        let SoundEffect:SKAction = SKAction.playSoundFileNamed("Thrusters2.mp3", waitForCompletion: false)
        
        HealthBar?.runAction(moveX)
        
        HealthBar?.runAction(moveY)
        
        ship.runAction(move)
        
        ship.runAction(movingAnimation)
        
        ship.runAction(SoundEffect)
    }
    
    func removeGestures(){
        
        println("we done removed gestures")
        
        rotateRect.removeTarget(self, action: "rotateView:")
        
        self.view?.gestureRecognizers?.removeAll()
    }
    
    //End Gestures functions
    
    func setUpAnimation(){
        
        let atlas = SKTextureAtlas (named: "Ship")
        
        
        var array = [String]()
        
        for var i = 1; i <= 12; i++ {
            
            let nameString = String(format: "Ship%i",i)
            array.append(nameString)
            
        }
        
        var atlasTextures:[SKTexture] = []
        
        for (var i = 0; i < array.count; i++){
            
            let texture:SKTexture = atlas.textureNamed(array[i])
            atlasTextures.insert(texture, atIndex: i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/30, resize:true, restore:false)
        
        movingAnimation = SKAction.repeatAction(atlasAnimation, count: 2)
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // function that convert degrees to radians
    func DegreesToRadians(value:Double) -> Double {
        
        return value * M_PI / 180.0
    }
    // function that convert radians to degrees
    func RadiansToDegrees(value:Double) -> Double {
        
        return value * 180.0 / M_PI
    }
    
    
    
}
