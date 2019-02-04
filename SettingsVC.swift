//
//  SettingsVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-06-01.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//necessary imports
import Foundation
import UIKit

//initial variable for racket sensitivity
var userRacketSensitivity = 0.1

class SettingsVC: UIViewController {
    
    //links label to view controller
    @IBOutlet weak var lbl: UILabel!
    
    //links slider to view controller as action
    @IBAction func slider(_ sender: UISlider) {
        //chnges label with the user's manipulation
        lbl.text = String(sender.value)
        //changes racket sensitivty accordingly
        userRacketSensitivity = 1/(Double(sender.value))
    }
    
}
