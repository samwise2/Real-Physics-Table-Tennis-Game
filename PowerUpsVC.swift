//
//  PowerUpsVC.swift
//  ping pong with gravity
//
//  Created by Sam Orend on 2018-06-02.
//  Copyright © 2018 Sam Orend. All rights reserved.
//

//necessary imports
import Foundation
import UIKit

//creates cases for power up types: slowMo and fireBall
enum powerType {
    case slowMo
    case fireBall
}

//declares class for view controller
class PowerUpsVC: UIViewController {
    
    //links button as an action
    @IBAction func slowMo(_ sender: UIButton) {
        //declares power up variable as slowMo
        currentPowerUp = powerType.slowMo
    }
    //links button as action
    @IBAction func fireBall(_ sender: UIButton) {
        //declares power up as fireball
        currentPowerUp = powerType.fireBall
    }
    
}

