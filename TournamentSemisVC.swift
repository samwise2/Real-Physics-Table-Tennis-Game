//
//  TournamentSemisVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-06-08.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

import Foundation
import UIKit

//declares class for view controller
class TournamentSemisVC : UIViewController {
    
    //links button as action
    @IBAction func advanceToFinal(_ sender: UIButton) {
        //sends user to game at medium difficulty
        moveToGame(game: .medium)
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
