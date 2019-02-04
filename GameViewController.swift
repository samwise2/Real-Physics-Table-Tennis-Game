//
//  GameViewController.swift
//  ping pong game
//
//  Created by Sam Orend on 2018-05-01.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//imports necessary frameworks
import UIKit
import SpriteKit
import GameplayKit

//variable for the current difficulty level
var currentGameType = gameType.medium
//variable for the selected power up
var currentPowerUp = powerType.fireBall
//variable for the current basic mode they are in arcade or tournament
var currentBasicMode = basicMode.arcade

class GameViewController: UIViewController {
    //links advance to semi final button to view
    @IBOutlet var advanceToSemi: UIButton!
    //links advance to final button to view
    @IBOutlet var advanceToFinal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                scene.gameViewController = self
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    //function to hide the un hide the semi final label
    func unHideSemiFinalLabel() {
        advanceToSemi.isHidden = false
    }
    //function to hide the semi final label
    func hideSemiFinalLabel() {
        advanceToSemi.isHidden = true
    }
    //function to hide the final label
    func hideFinalLabel() {
        advanceToFinal.isHidden = true
    }
    //function to un hide the final label
    func unHideFinalLabel() {
        advanceToFinal.isHidden = false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .landscape
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print(UIDevice.current.orientation.isLandscape)
        
    }
}
