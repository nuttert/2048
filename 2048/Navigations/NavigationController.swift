//
//  NavigationController.swift
//  2048
//
//  Created by vlad on 26.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

 
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if self.topViewController as? BeginingViewController != nil || self.topViewController as? SettingsViewController != nil{
        return .portrait
        }
        return .all
    }
    

}
