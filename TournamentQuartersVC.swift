//
//  TournamentQuartersVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-06-06.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//necessary includes
import Foundation
import UIKit

//class for view controller
class TournamentQuartersVC: UIViewController {

    //links button to action on press
    @IBAction func advanceToQuarter(_ sender: UIButton) {
        //sends user to easy game mode
        moveToGame(game: .easy)
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
