//
//  File.swift
//  2048
//
//  Created by vlad on 30.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

struct Animations{
    static func animationWithScale(_ item:ItemView,withScaled cofficient:CGFloat){
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                       delay: 0.0,
                                                       options: [],
                                                       animations: {item.transform = CGAffineTransform.identity.scaledBy(x: cofficient, y: cofficient)},
                                                       completion: {finished in
                                                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                                                                       delay: 0.0,
                                                                                                       options: [],
                                                                                                       animations: { item.transform = .identity})})
        
    }
}
