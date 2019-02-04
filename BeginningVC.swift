//
//  BeginningVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-06-06.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//necessary imports
import Foundation
import UIKit

//creates 2 possible cases for the basicMode that the user is in arcade or tournament
enum basicMode {
    case arcade
    case tournament
}
//declares class for view controller
class BeginningVC: UIViewController {
    
    //links button as action
    @IBAction func tournamentButton(_ sender: UIButton) {
        //assigns global variable for basic mode based on selection
        currentBasicMode = .tournament
    }
    //links button as action
    @IBAction func arcadeButton(_ sender: UIButton) {
        //assigns global variable for basic mode based on selection
        currentBasicMode = .arcade
    }
    
}
