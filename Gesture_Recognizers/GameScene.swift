//
//  GameScene.swift
//  Gesture_Recognizers
//
//  Created by Jonathan Green on 8/4/15.
//  Copyright (c) 2015 Jonathan Green. All rights reserved.
//

import SpriteKit

enum BodyType:UInt32 {
    
    case monster = 1
    case player = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
   //Actions Varables
    var seq:SKAction?
    
    var repeat:SKAction?
    
    var followAction:SKAction?
    
    var reversePath:SKAction?
    
    var movingAnimation:SKAction?
    //Actions Varables End
    
    //Sprite Varables
    var ship:SKSpriteNode?
    var target:SKSpriteNode?
    //Sprite Varables End


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
        
        
        //background
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPointMake((self.view!.bounds.width / 2), (self.view!.bounds.height / 2))

        addChild(bg)
        //background End
        
        //view.showsPhysics = true
        
        physicsWorld.contactDelegate = self
        
        self.anchorPoint = CGPointMake(0.0, 0.0)
        self.backgroundColor = SKColor.blackColor()
        
        //Skull
        let skull = SKSpriteNode(imageNamed: "skull")
        //var mySize = CGSize(skull.size.height/2)
        skull.physicsBody = SKPhysicsBody(texture: skull.texture, size: CGSizeMake(skull.size.width - 10, skull.size.height - 10))
        skull.physicsBody?.dynamic = false
        skull.physicsBody?.categoryBitMask = BodyType.monster.rawValue
        skull.position = CGPointMake((self.view!.bounds.width / 2), (self.view!.bounds.height / 2))
        self.addChild(skull)
        
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
        
        skull.runAction(repeat!)
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
        let repeatCreation:SKAction = SKAction.repeatAction(creationSeq, count: 20)
        
        self.runAction(repeatCreation)
        
        //Skull End
        
        //handling Ship Sprite
        ship = SKSpriteNode(imageNamed:"Ship")
        ship!.physicsBody = SKPhysicsBody(texture: ship!.texture, size: ship!.size)
        ship!.physicsBody?.dynamic = true
        ship!.physicsBody?.categoryBitMask = BodyType.player.rawValue
        //ship!.physicsBody?.collisionBitMask = BodyType.monster.rawValue
        ship!.physicsBody?.collisionBitMask = 0
        ship?.physicsBody?.contactTestBitMask = BodyType.monster.rawValue
        ship!.physicsBody?.affectedByGravity = false
        //ship?.physicsBody = SKPhysicsBody.
        ship!.position = CGPointMake((self.view!.bounds.width / 2), (self.view!.bounds.height / 2) - 250)
        addChild(ship!)
        //Ship End
        
        
        //Handles target Sprite
        target = SKSpriteNode(imageNamed:"target")
        addChild(target!)
        
        target!.position = CGPointMake(ship!.position.x, ship!.position.y + length)
        target!.alpha = 0
        //target End
        
        setUpAnimation()
        
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
        
        //this gets called automactically when to objects begin contact with one another
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let SoundEffect:SKAction = SKAction.playSoundFileNamed("Hit.mp3", waitForCompletion: false)
        
        switch(contactMask) {
            
        case BodyType.player.rawValue | BodyType.monster.rawValue:
            //either the conteckmask was the player or monster
            println("contact made")
            
            ship!.runAction(SoundEffect)
            
            
        default:
        return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        //this gets called automactically when to objects end contact with one another
    }
    //functions for detecting contact End
    
    
    //function that creates new Skulls
    func newSkull() {
        
        let skull = SKSpriteNode(imageNamed: "skull")
        skull.physicsBody = SKPhysicsBody(texture: skull.texture, size: CGSizeMake(skull.size.width - 10, skull.size.height - 10))
        skull.physicsBody?.dynamic = false
        skull.physicsBody?.categoryBitMask = BodyType.monster.rawValue
        skull.position = CGPointMake(0,0)
        self.addChild(skull)
        
        skull.runAction(repeat!)
    }
    //function that creates new Skulls End
    

    //handels Gestures functions
    func longPress(){
        
        println("longPressed")
    }
    
    func pinch(sender:UIPinchGestureRecognizer){
        
        ship!.xScale = sender.scale
        ship!.yScale = sender.scale
        
        println("Pinched velocity \(sender.velocity)")
    }
    
    func panView(sender:UIPanGestureRecognizer){
        
        println("pan")
        
        var touchLocation:CGPoint = sender.locationInView(self.view!)
        touchLocation = self.convertPointFromView(touchLocation)
        
        ship!.position = touchLocation
        
        println("X \(touchLocation.x)")
        println("Y \(touchLocation.y)")
    }
    
    func swipedRight(){
        
        println("swiped Right")
        
        ship!.zRotation = CGFloat (DegreesToRadians(270))
        offset = ship!.zRotation
        target!.alpha = 0
       
        
    }
    
    func swipedLeft(){
        
        println("swiped Left")
        
        ship!.zRotation = CGFloat (DegreesToRadians(90))
        offset = ship!.zRotation
        target!.alpha = 0
    }
    
    func swipedUp(){
        
        println("swiped Up")
        ship!.zRotation = CGFloat (DegreesToRadians(0))
        offset = ship!.zRotation
        target!.alpha = 0
        
    }
    
    func swipedDown(){
        
        println("swiped Down")
        ship!.zRotation = CGFloat (DegreesToRadians(180))
        offset = ship!.zRotation
        target!.alpha = 0
        
    }
    
    
    func rotateView(sender:UIRotationGestureRecognizer){
        
        if (sender.state == .Began) {
            
            //do anything you want when the rotation gesture has begun
            
            let fade:SKAction = SKAction.fadeAlphaTo(1, duration: 0.5)
            target!.runAction(fade)
            
            println("we done Started")
        }
        
        if (sender.state == .Changed) {
            
            //do anything you want when the rotation gesture has ended
            
            theRotation = CGFloat(sender.rotation) + self.offset
            theRotation = theRotation * -1
            
            ship!.zRotation = theRotation
            target?.zRotation = theRotation
            
            let xDistance:CGFloat = sin(theRotation) * length
            let yDistance:CGFloat = cos(theRotation) * length
            
            target!.position = CGPointMake(ship!.position.x - xDistance, ship!.position.y + yDistance)
            
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
        
        let fade:SKAction = SKAction.fadeAlphaTo(0, duration: 0.5)
        target!.runAction(fade)
        
        let move:SKAction = SKAction.moveTo(target!.position, duration: 0.6)
        move.timingMode = .EaseOut
        
        let SoundEffect:SKAction = SKAction.playSoundFileNamed("Thrusters2.mp3", waitForCompletion: false)
        
        ship!.runAction(move)
        
        ship!.runAction(movingAnimation)
        
        ship!.runAction(SoundEffect)
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
