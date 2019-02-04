//
//  TournamentFinalsVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-06-08.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//necessary frameworks
import Foundation
import UIKit

//creates a class for the view controller
class TournamentFinalsVC : UIViewController {
    
    //links button to view with an action
    @IBAction func goToFinals(_ sender: UIButton) {
        //sends the user to game mode hard if pressed
        moveToGame(game: .hard)
    }
    
    //moveToGame function
    func moveToGame(game: gameType)
    {
        //intializes the gameVC as the view controller
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        //assigns selected game type
        currentGameType = game
        //navigates to view
        self.navigationController?.pushViewController(gameVC, animated: true)
        
    }
}
