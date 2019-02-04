//
//  GameScene.swift
//  test game
//
//  Created by Sam Orend on 2018-04-26.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//import spritekit and ui kit the game frameworks used for this project
import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //references the GameViewController to access and change variables and send information
    var gameViewController : GameViewController!
    
    //declares the sound files which are used for the contact and fireball sound effects
    let pingpongsound = SKAction.playSoundFileNamed("pingpongsoundeffect.mp3", waitForCompletion: false)
    let fireBallSound = SKAction.playSoundFileNamed("fireBallEffect.mp3", waitForCompletion: false)
    
    //bools to keep track of whether or not impulse has been applied by the user or enemy on the serve
    var impulseAppliedUser=false
    var impulseAppliedPlayer2 = false
    //variable to keep track of the number of bounces on one side of the table
    var numBouncesPlusRacket = 0
    //variables which keep track of the x and y positions of the ball in the last frame
    var prevPosX = 0.0
    var prevPosY = 0.0
    //bool which determines the direction of the ball in the y direction before hit by the AI
    var bouncingUp = true
    //bool that checks if the score can be increased
    var canAddScore = true
    //variable which determines how quickly the AI moves towards the ball
    var enemyTiming = 0.0
    //variables which check the previous components of the rackets velocity
    var prevRacketXVelocity = 0.0
    var prevRacketYVelocity = 0.0
    //bool variable to see if a contact was missed
    var needSafetyNet = false
    //variable that keeps track of how many times the ball has crossed the net to determine when powerup can be activated
    var powerCounter = 0
    //boolean variable which is equal to whether or not a power up can be currently used
    var powerUpAvailable = false
    //boolen variable which checks if a power up was activated
    var powerUpActivated = false
    //variable which determines when the AI begins to react to incoming shot
    var reactionDistance = 0.5
    //boolean variable which checks if a fireball can be applied
    var applyFireBall = false
    
    //declares a world which will hold all relevant nodes
    let world = SKNode()
    //declares variables for rackets, ball, table and world view
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var user = SKSpriteNode()
    var table = SKSpriteNode()
    //node which is shown when a power up can be used
    var activatePower = SKSpriteNode()
    //decalres an array to keep track of the score
    var score = [Int]()
    //labels for the score
    var userScore = SKLabelNode()
    var opponentScore = SKLabelNode()
    //label for when the game reaches deuce
    var DeuceLabel = SKLabelNode()
    //label for when the game is over
    var winningLabel = SKLabelNode()
    //labels which are used to demonstrate the charging up of the power up
    var P = SKLabelNode()
    var O = SKLabelNode()
    var W = SKLabelNode()
    var E = SKLabelNode()
    var R = SKLabelNode()
    var coolP = SKLabelNode()
    var coolO = SKLabelNode()
    var coolW = SKLabelNode()
    var coolE = SKLabelNode()
    var coolR = SKLabelNode()
    //variables for the pause and restart buttons
    var pauseButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    //initializes emitter variable as an emmiter node, with link to particle
    let emitter = SKEmitterNode(fileNamed: "ballTrail.sks")
    let powerUpEmitter = SKEmitterNode(fileNamed: "FireParticle.sks")
    
    override func didMove(to view: SKView) {
        
        //adds world to view, done for pausing purposes
        addChild(world)
        //adds ball and rackets to world
        world.addChild(ball)
        world.addChild(user)
        world.addChild(enemy)
        
        //starts the game
        startGame()
        
        //declares the physics world as the contact delegate so it can manage collisions in the scene
        physicsWorld.contactDelegate = self
        
        //adds winning label to scene and hides it because the game has not been won yet
        winningLabel = self.childNode(withName: "winningLabel") as! SKLabelNode
        winningLabel.isHidden = true
        //adds score labels to the screen
        userScore = self.childNode(withName: "userScore") as! SKLabelNode
        opponentScore = self.childNode(withName:"opponentScore") as! SKLabelNode
        //adds deuce label to the screen and hides it becaue the game has not reached deuce yet
        DeuceLabel = self.childNode(withName:"DeuceLabel") as! SKLabelNode
        DeuceLabel.isHidden = true
        //adds power up uncharged letters to the screen
        P = self.childNode(withName: "P") as! SKLabelNode
        O = self.childNode(withName: "O") as! SKLabelNode
        W = self.childNode(withName: "W") as! SKLabelNode
        E = self.childNode(withName: "E") as! SKLabelNode
        R = self.childNode(withName: "R") as! SKLabelNode
        
        //adds charged up letters to the screen
        coolP = self.childNode(withName: "coolP") as! SKLabelNode
        coolP.isHidden = true
        coolO = self.childNode(withName: "coolO") as! SKLabelNode
        coolO.isHidden = true
        coolW = self.childNode(withName: "coolW") as! SKLabelNode
        coolW.isHidden = true
        coolE = self.childNode(withName: "coolE") as! SKLabelNode
        coolE.isHidden = true
        coolR = self.childNode(withName: "coolR") as! SKLabelNode
        coolR.isHidden = true
        
        //declares that the ball and both rackets should use precise collision detection to avoid missing contacts at high speeds
        ball.physicsBody?.usesPreciseCollisionDetection = true
        user.physicsBody?.usesPreciseCollisionDetection = true
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        
        //adds activate power up button
        activatePower = self.childNode(withName: "activatePower") as! SKSpriteNode
        //changes texture of button according to user choice
        if currentPowerUp == .slowMo {
            activatePower.texture = SKTexture(imageNamed:"slowMo")
        }
        if currentPowerUp == .fireBall {
            activatePower.texture = SKTexture(imageNamed:"fireBall")
        }
        //hides button because a power up can't be activated right at the beginning of the game
        activatePower.isHidden = true
        //adds restart and pause buttons
        restartButton = self.childNode(withName: "restartButton") as! SKSpriteNode
        pauseButton = self.childNode(withName: "pauseButton") as! SKSpriteNode
        //adds table, rackets and ball to scene
        table=self.childNode(withName: "table") as! SKSpriteNode
        enemy=self.childNode(withName: "enemy") as! SKSpriteNode
        user=self.childNode(withName: "user") as! SKSpriteNode
        ball=self.childNode(withName: "ball") as! SKSpriteNode
        
        //sets target to self to create tail effect
        emitter?.targetNode = self
        //adds emitter particles to ball node
        ball.addChild(emitter!)
        
        //sets target of a power up emitter to itself and intializes the emitter as a child of the user racket
        powerUpEmitter?.targetNode = self
        user.addChild(powerUpEmitter!)
        //sets birth rate to 0 because power up cannot be intiated at the beginning
        powerUpEmitter?.particleBirthRate = 0
        
        
        //creates delay before starting game
        DispatchQueue.main.asyncAfter(deadline: .now() + 5)
        {
            //prints intiial positions
            print("\(currentPowerUp)")
            print("\(self.user.position.x) user position x")
            print("\(self.user.position.y) user position y")
            print("\(self.ball.position.x) ball position")
            print("\(self.ball.position.y) ball position")
        }
        
        //creates a switch which  adjusts the speed at which the racket moves towards the ball and how early the enemy 'reacts' to the incoming shot
        switch currentGameType {
            //decreases amount of reaction time and decreases speed for easy difficulty
        case.easy:
            enemyTiming = 1.1
            reactionDistance = 0.5
            break
            //fairly neutral values for medium
        case.medium:
            enemyTiming = 0.8
            reactionDistance = 0.7
            break
            //increases reaction time and speed for hard difficulty
        case.hard:
            enemyTiming = 0.6
            reactionDistance = 0.7
            break
            //no adjustments for a 2 player gme
        case.player2:
            break
        }
        
    }
    
    //start game function
    func startGame() {
        //intializes scores and score labels
        score = [0,0]
        userScore.text = "\(score[0])"
        opponentScore.text = "\(score[1])"
        //resets the power up letters so that they are all uncharged
        resetLetters()
        //calls user serve function
        userServe()
    }
    
    //function for the user to serve
    func userServe()
    {
        //resets the positions of the user racket and the ball
        user.position.x = CGFloat(400)
        user.position.y = CGFloat(40)
        ball.position.x = CGFloat(340)
        ball.position.y = CGFloat(30)
        //pauses scene to give user time to reset and feeling of seperation between points
        view?.scene?.isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            //unpuases the scene after 2 seconds
            self.view?.scene?.isPaused = false
        }
        //sets impulse created by user to false so that they can serve
        impulseAppliedUser = false
        //begin particle emission again after ball has been reset
        emitter?.particleBirthRate = 1000
    }
    
    //function for enemy to serve
    func enemyServe()
    {
        //resets ball and enemy racket positions
        enemy.position.x = CGFloat(-400)
        enemy.position.y = CGFloat(40)
        ball.position.x = CGFloat(-290)
        ball.position.y = CGFloat(30)
        //pauses scene to create feeling of seperation between points
        view?.scene?.isPaused = true
        //after 2 seconds...
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            //unpauses the scene
            self.view?.scene?.isPaused = false
        }
        //sets impulse applied to false so that the enemy can apply an impulse and serve
        impulseAppliedPlayer2 = false
        //resumes particle birth after ball has been reset
        emitter?.particleBirthRate = 1000
        //as long as the game is not 2 player
        if currentGameType != .player2
        {
            //create a small delay and then apply an impulse to serve the ball
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                self.ball.physicsBody?.applyImpulse(CGVector(dx:4, dy:-4))
            }
        }
    }
    
    //a function which resets the enemy timing after it is adjust later on, used primarily for resetting the game
    func resetEnemyTiming()
    {
        if currentGameType == .easy
        {
            enemyTiming = 1
        }
        if currentGameType == .medium
        {
            enemyTiming = 0.8
        }
        if currentGameType == .hard
        {
            enemyTiming = 0.6
        }
    }
    
    //function to add score the the score board, takes in the player who won
    func addScore(playerWhoWon: SKSpriteNode)
    {
        if playerWhoWon == user {
            //adds score the correct position in array
            score[0] += 1
            //updates score on label
            userScore.text = "\(score[0])"
            //resets the velocity of ball to 0
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //resets the counter for number of contacts of the ball with the racket and table
            numBouncesPlusRacket = 0
            //resets the counter that is used to make the power up available
            powerCounter = 0
            //checks if the current power up is a fireball
            if currentPowerUp == .fireBall
            {
                //sets applyFireBall to false
                applyFireBall = false
                //sets particle emission to 0
                powerUpEmitter?.particleBirthRate = 0
            }
            //resets the power up letters and enemyTiming
            resetLetters()
            resetEnemyTiming()
            //calls user serve function
            userServe()
        }
        else if playerWhoWon == enemy {
            //adds score the correct position in array
            score[1] += 1
            //updates score on label
            opponentScore.text = "\(score[1])"
            //resets the velocity of ball to 0
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //resets the counter for number of contacts of the ball with the racket and table
            numBouncesPlusRacket = 0
            //resets the counter that is used to make the power up available
            powerCounter = 0
            //checks if the current power up is a fireball
            if currentPowerUp == .fireBall
            {
                //sets applyFireBall to false
                applyFireBall = false
                //sets particle emission to 0
                powerUpEmitter?.particleBirthRate = 0
            }
            //resets the power up letters and enemyTiming
            resetLetters()
            resetEnemyTiming()
            //calls user enemy function
            enemyServe()
        }
    }
    
    //function to reset the game
    func resetGame()
    {
        //hides the label that says someone has won
        winningLabel.isHidden = true
        //resets impulse variables to allow a first serve
        impulseAppliedUser = false
        impulseAppliedPlayer2 = true
        //calls the start game function
        startGame()
    }
    
    //function to check if the ball is in range for the fireball to be applied
    func inHitBox() -> Bool
    {
        //checks if the ball is in the appropriate proximity
        if(ball.position.x - user.position.x > -80)
        {
            if(ball.position.y - user.position.y < 8) || (ball.position.y - user.position.y > -8)
            {
                //returns true if ball is in hitbox
                return true
            }
        }
        //otherwise it returns false
        return false
    }
    
    //function that returns all of the letters back to their uncharged state
    func resetLetters()
    {
        coolP.isHidden = true
        coolO.isHidden = true
        coolW.isHidden = true
        coolE.isHidden = true
        coolR.isHidden = true
        P.isHidden = false
        O.isHidden = false
        W.isHidden = false
        E.isHidden = false
        R.isHidden = false
    }
    //function to use the given power up when it is available
    func usePowerUp ()
    {
        //if the selected power up is slow motion
        if currentPowerUp == .slowMo
        {
            //decrease the speed of the enemy movement
            enemyTiming += 1
        }
        //if the selected power up is a fireball
        if currentPowerUp == .fireBall
        {
            //makes the powerUpEmitter visible
            powerUpEmitter?.particleBirthRate = 1000
            //allows the fireball to be applied
            applyFireBall = true
            
        }
    }
    
    //function which runs every frame
    override func update(_ currentTime: TimeInterval) {
        //checks if the user is playing a tournament and hides the appropriate labels from the previous round if applicable
        if currentBasicMode == .tournament && currentGameType == .medium
        {
            self.gameViewController.hideSemiFinalLabel()
        }
        if currentBasicMode == .tournament && currentGameType == .hard
        {
            self.gameViewController.hideFinalLabel()
        }
        
        //sets a boolean to whether or not the ball is in the hit box for the racket
        var isInRange = inHitBox()
        //if the ball is in the hit box and the fireball can be applied
        if applyFireBall == true && isInRange == true
        {
            //declares a variable which adjusts the angle of impulse depending on height
            var vertAdjust = ball.position.y/75
            //applies fireball impulse
            ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -vertAdjust))
            //plays sound effect
            run(fireBallSound)
            //sets boolean for if the power up can be used to false
            applyFireBall = false
            //stops fire effect on racket
            powerUpEmitter?.particleBirthRate = 0
        }
        //checks if a powerUp is available from the current or previous rally
        if powerUpAvailable == true {
            //if so unhides the node which can be used to activate it
            activatePower.isHidden = false
        }
        
        //initializes a variable which is used by the AI to adjust based on incoming shot
        var verticalAdjustmentFactor = 1.9
        
        //checks if the score is 10-10
        if(score[0] == 10 && score[1] == 10)
        {
            //un hides the deuce label
            DeuceLabel.isHidden = false
        }
        //checks if the user has scored 11 points and has won by a differenc of 2
        if (score[0] >= 11 && score[0]-score[1] >= 2)
        {
            //hides deuce label
            DeuceLabel.isHidden = true
            //pauses the scene as game is over
            view?.scene?.isPaused = true
            //if it is a 2 player game then prints the appropriate winning text
            if currentGameType == .player2
            {
                self.winningLabel.text = "Player 1 Won!"
            }
            else
            {
                //checks if it is in arcade mode
                if currentBasicMode == .arcade
                {
                    //print simple winning message
                    self.winningLabel.text = "Congrats! You Won :)"
                }
                //checks if game has been won in tournament mode
                if currentBasicMode == .tournament
                {
                    //checks game difficulty
                    if currentGameType == .easy {
                        //prints that the user has won the quarter final round
                        self.winningLabel.text = "Congrats! You Won The Quarter Final"
                        //unhides the button to go to the semi finals
                        self.gameViewController.unHideSemiFinalLabel()
                    }
                    //checks if difficulty is medium
                    if currentGameType == .medium {
                        //prints that user has won semi final round
                        self.winningLabel.text = "Congrats! You Won The Semi Final"
                        //unhides the button which allows user to advance to finals
                        self.gameViewController.unHideFinalLabel()
                    }
                    //if the difficulty is hard then the user has won the tournament
                    if currentGameType == .hard {
                        self.winningLabel.text = "Congrats! You are the Champion!"
                    }
                }
            }
            //otherwise unhide the winning label
            winningLabel.isHidden = false
        }
        
        //checks if the enemy has won by acheiving a score of 11 by a difference greater than 2
        if(score[1] >= 11 && score[1]-score[0] >= 2)
        {
            //hides deuce label because someone has won
            DeuceLabel.isHidden = true
            //pauses the scene
            view?.scene?.isPaused = true
            //if the game type is 2 player
            if currentGameType == .player2
            {
                //prints appropriate winning text
                self.winningLabel.text = "Player 2 Won!"
            }
            else
            {
                //otherwise prints that the enemy racket won the game
                self.winningLabel.text = "The Enemy Won :("
            }
            //unhides the winning label
            winningLabel.isHidden = false
        }
        
        //if the current game is not 2 players
        if currentGameType != .player2
        {
            //variable which is equal to when enemy racket starts to react to the incoming ball
            var proximityX = CGFloat(reactionDistance) * (ball.physicsBody?.velocity.dx)!
            //makes the proximity positive
            if(proximityX < 0)
            {
                proximityX *= -1
            }
            //if the ball is within the appropriate proximity and the incoming velocity of the ball in the x direction is still negative
            if(enemy.position.x - ball.position.x) > -proximityX && (ball.physicsBody?.velocity.dx)! <= 0
            {
                //begin reaction
                //variable which is equal to reaction of AI in y direction
                var proximityY = CGFloat(reactionDistance) * (ball.physicsBody?.velocity.dy)!
                //checks if the ball is bouncing fairly high
                if(proximityY > 400 || proximityY < -400)
                {
                    //adjusts the vertical component of the AI racket movement
                    verticalAdjustmentFactor = 1.4
                }
                if(proximityY > 700 || proximityY < -700)
                {
                    //adjusts the vertical component of the AI racket movement
                    verticalAdjustmentFactor = 1.1
                }
                //ensures that the proximity is positive
                if(proximityY < 0)
                {
                    proximityY *= -1
                }
                //checks if the ball is bouncing up before it is contacted by the AI
                if(ball.position.y - CGFloat(prevPosY)) > 0
                {
                    //begins reaction by moving upwards beyond position of ball proporitonally to its speed
                    enemy.run(SKAction.moveTo(y: ball.position.y+(proximityY/CGFloat(verticalAdjustmentFactor)), duration: enemyTiming))
                    //moves to x position of ball
                    enemy.run(SKAction.moveTo(x: ball.position.x, duration: enemyTiming))
                    //sets boolean that the ball is bouncing upwards to true
                    bouncingUp = true
                    
                }
                //or if it is bouncing down
                if(ball.position.y - CGFloat(prevPosY)) < 0
                {
                    //sets boolean to show that ball is bouncing down
                    bouncingUp = false
                    //if the enemy racket is supposed to move below the top of the table
                    if ((ball.position.y - proximityY/2) < 0)
                    {
                        //stop movement at top of table
                        enemy.run(SKAction.moveTo(y: 0, duration: enemyTiming))
                    }
                    else
                    {
                        //otherwise run to below height of the ball in y direction proportionally to the spped
                        enemy.run(SKAction.moveTo(y: ball.position.y-(proximityY/2), duration: enemyTiming))
                    }
                    //moves to x position of the ball
                    enemy.run(SKAction.moveTo(x: ball.position.x, duration: enemyTiming))
                }
            }
            else
            {
                //if the ball is not within appropriate proximity then reset back to 'ready' position
                enemy.run(SKAction.moveTo(y: 30, duration: 0.5))
                enemy.run(SKAction.moveTo(x: -400, duration: 0.5))
            }
        }
        
        //checks if the ball has bounced too many times on the enemy's side of the table
        if ball.position.x < 0 && numBouncesPlusRacket > 4
        {
            //set velocity of ball to zero
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //add score to the user who won the point
            addScore(playerWhoWon: user)
        }
        //checks if the ball has bounced too many times on the users's side of the table
        if ball.position.x > 0 && numBouncesPlusRacket > 4
        {
            //set velocity of ball to zero after point is over
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //adds score the the enemy racket who won the point
            addScore(playerWhoWon: enemy)
        }
        //if the sign of the ball's x position changes
        if ball.position.x < 0 && prevPosX > 0
        {
            //reset number of contacts counter
            numBouncesPlusRacket = 0
            //increase power up counter
            powerCounter += 1
            //depending on the number of shots in this rally unhide the charged letters progressively
            if powerCounter == 1
            {
                P.isHidden = true
                coolP.isHidden = false
            }
            if powerCounter == 2
            {
                O.isHidden = true
                coolO.isHidden = false
            }
            if powerCounter == 3
            {
                W.isHidden = true
                coolW.isHidden = false
            }
            if powerCounter == 4
            {
                E.isHidden = true
                coolE.isHidden = false
            }
            if powerCounter == 5
            {
                R.isHidden = true
                coolR.isHidden = false
            }
        }
        //if the ball's x position changes signs in the other direction
        if ball.position.x > 0 && prevPosX < 0
        {
            //increase the power up counter
            powerCounter+=1
            //depending on the number of shots in this rally unhide the charged letters progressively
            if powerCounter == 1
            {
                P.isHidden = true
                coolP.isHidden = false
            }
            if powerCounter == 2
            {
                O.isHidden = true
                coolO.isHidden = false
            }
            if powerCounter == 3
            {
                W.isHidden = true
                coolW.isHidden = false
            }
            if powerCounter == 4
            {
                E.isHidden = true
                coolE.isHidden = false
            }
            if powerCounter == 5
            {
                R.isHidden = true
                coolR.isHidden = false
            }
            numBouncesPlusRacket = 0
        }
        //if all of the letters are charged
        if coolP.isHidden == false && coolO.isHidden == false && coolW.isHidden == false && coolE.isHidden == false && coolR.isHidden == false
        {
            //declares that the power up can now be activated
            powerUpAvailable = true
        }
        //if the ball is outside of the view
        if (!intersects(ball)) {
            //stops the ball trail
            emitter?.particleBirthRate = 0
            //if the ball is out past the opponents side and a contact was made on that side
            if (ball.position.x < -400) && numBouncesPlusRacket >= 1
            {
                //the user won the point
                addScore(playerWhoWon: user)
            }
            //if he ball is out past the opponents side but contact was not made
            else if (ball.position.x < -400) && numBouncesPlusRacket < 1
            {
                //the user won the point
                addScore(playerWhoWon: enemy)
            }
            //if the ball is out past the users side and contact was made
            if ball.position.x > 400 && numBouncesPlusRacket >= 1
            {
                //enemy won the point
                addScore(playerWhoWon: enemy)
            }
            //if the ball is out past the users side and contact was not made
            else if ball.position.x > 400 && numBouncesPlusRacket < 1
            {
                //the user won the point
                addScore(playerWhoWon: user)
            }
        }
        //if the user racket and the ball are within 80 unis and the user has not served the ball yet
        if((user.position.x - ball.position.x) > -80 && impulseAppliedUser == false)
        {
            //and the user and the ball are close in proximity
            if((user.position.y - ball.position.y) < 10 || (user.position.y - ball.position.y) > -10)
            {
                //let user serve the ball by applying impulse
                ball.physicsBody?.applyImpulse(CGVector(dx: -4, dy: -3))
            }
            //don't allow another serve this rally
            impulseAppliedUser=true
            impulseAppliedPlayer2 = true
        }
        //if the current game type is player 2
        if currentGameType == .player2
        {
            //if the 2nd player and the ball are close in proximity and the 2nd player has not served yet
            if((enemy.position.x - ball.position.x) > -80 && impulseAppliedPlayer2 == false)
            {
                //if the ball and the 2nd player are close in the y-direction
                if((enemy.position.y - ball.position.y) < 10 || (enemy.position.y - ball.position.y) > -10)
                {
                    //apply impulse and serve
                    ball.physicsBody?.applyImpulse(CGVector(dx: 4, dy: -3))
                }
            }
            //don't allow another serve this rally
            impulseAppliedPlayer2 = true
            impulseAppliedUser = true
        }
        //checks if the ball needs a safety net in the next rally
        needSafetyNet = inHitBox()
        //sets previous position to the current x and y positions of the ball
        prevPosX = Double(ball.position.x)
        prevPosY = Double(ball.position.y)
    }
    //function to deal with user screen interaction
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first
        else {
            return
        }
        //gets location of touch
        let touchLocation = touch.location(in: self)
        //if user touches pause button
        if touchLocation.x < -360 && touchLocation.x > -420
        {
            if touchLocation.y > 280 && touchLocation.y < 330
            {
                //pause view
                view?.scene?.isPaused = true
                //pauseButton.texture = SKTexture(imageNamed:"play")
            }
            else
            {
                //otherwise unpause scene
                view?.scene?.isPaused = false
            }
        }
        //if user touches restart button
        if touchLocation.x < -490 && touchLocation.x > -550
        {
            if touchLocation.y > 280 && touchLocation.y < 330
            {
                //call start game function again
                resetGame()
            }
        }
        //if the power up can be activated
        if powerUpAvailable == true
        {
            //if the user touches the node
            if touchLocation.x > 450 && touchLocation.x < 530
            {
                if touchLocation.y < 310 && touchLocation.y > 200
                {
                    //declares that the power up has been activated
                    powerUpActivated = true
                    //resets the letter to their uncharged state
                    resetLetters()
                    //resets that now the power cannot be activated a scond time
                    powerUpAvailable = false
                    //hides node
                    activatePower.isHidden = true
                    //calls use power up function
                    usePowerUp()
                }
            }
        }
     }
    //function to deal with touch and drag input
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var executionDuration = userRacketSensitivity
        for touch in touches {
            //gets location of drag
            let location = touch.location(in: self)
            //checks if user dragged over pause button
            if location.x < -360 || location.x > -420
            {
                if location.y > 280 && location.y < 330
                {
                    //pauses view
                    view?.scene?.isPaused = true
                }
                //otherwise scene is unpaused
                else
                {
                    view?.scene?.isPaused = false
                }
            }
            
            if currentGameType == .player2 {
                //if the touch location is positive
                if location.x > 0 {
                    //move the user to that point
                    user.run(SKAction.moveTo(x: location.x, duration: executionDuration))
                    //keeps racket in appropriate area
                    if location.y < 0
                    {
                        user.run(SKAction.moveTo(y: 0, duration: executionDuration))
                    }
                    user.run(SKAction.moveTo(y: location.y, duration: executionDuration))
                }
                if location.x < 0 {
                    //if the touch is negative then move the enemy racket to that position
                    enemy.run(SKAction.moveTo(x: location.x, duration: executionDuration))
                    //keeps racket in appropriate area
                    if location.y < 0
                    {
                        enemy.run(SKAction.moveTo(y: 0, duration: executionDuration))
                    }
                    enemy.run(SKAction.moveTo(y: location.y, duration: executionDuration))
                    
                }
            }
            else {
                //move the user racket to touch location
                //keeps racket in apprpriate area
                if location.x < 0
                {
                    user.run(SKAction.moveTo(x: 0, duration: executionDuration))
                }
                else
                {
                    user.run(SKAction.moveTo(x: location.x, duration: executionDuration))
                }
                //keeps racket in appropriate area
                if location.y < 0
                {
                    user.run(SKAction.moveTo(y: 0, duration: executionDuration))
                }
                else
                {
                    user.run(SKAction.moveTo(y: location.y, duration: executionDuration))
                }
                
            }
        }
    }
    //if the ball contacts a physics body
    func didBegin(_ contact: SKPhysicsContact) {
        //add one to the contact counter
        numBouncesPlusRacket += 1
        //play sound effect
        run(pingpongsound)
    }
    
}
