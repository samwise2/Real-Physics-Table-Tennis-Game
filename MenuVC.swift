//
//  MenuVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-05-16.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//necessary imports
import Foundation
import UIKit

//creates cases for different kinds of game modes
enum gameType {
    case easy
    case medium
    case hard
    case player2
}

//declares class for view controller
class MenuVC: UIViewController {
    //links button as an action
    @IBAction func Player2(_ sender: Any) {
        //sends user to 2 player mode
        moveToGame(game: .player2)
    }
    //links button as an action
    @IBAction func Easy(_ sender: Any) {
        //sends user to easy mode
        moveToGame(game: .easy)
    }
    //links button as an action
    @IBAction func Medium(_ sender: Any) {
        //sends user to medium mode
        moveToGame(game: .medium)
    }
    //links button as an action
    @IBAction func Hard(_ sender: Any) {
        //sends user to hard mode
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
