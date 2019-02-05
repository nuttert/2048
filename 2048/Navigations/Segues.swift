//
//  Segues.swift
//  2048
//
//  Created by vlad on 22.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit


// Menu ----->>>> Game
class SeguesToNewGame: UIStoryboardSegue {
    override func perform() {
        animation()
    }
    private func animation(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        let originCenter = fromViewController.view.center
        
        toViewController.view.center = originCenter
        if let fromViewController = fromViewController as? BeginingViewController {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3.0,
                                                       delay: 0.0,
                                                       options: [],
                                                       animations: {
                                                        fromViewController.blurEffectView.alpha = 0.0
                                                        },
                                                       completion: {finished in
                                                        fromViewController.blurEffectView.alpha = 1.0 
                                                        fromViewController.navigationController?.pushViewController(toViewController,animated: false)
                                                        
            })
        }
        
    }
}


// Menu <<<<----- Game
class SeguesFromGameToMenu: UIStoryboardSegue {
    override func perform() {
        animation()
    }
    private func animation(){
        let fromViewController = self.source
        
        guard let window = fromViewController.view.superview else { assert(false);return}
        let bluerEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect:bluerEffect)
        blurEffectView.frame = window.bounds
        window.addSubview(blurEffectView)
       
            blurEffectView.alpha = 0.0
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0,
                                                       delay: 0.0,
                                                       options: [],
                                                       animations: {
                                                        blurEffectView.alpha = 1.0},
                                                       completion: {finished in
                                                        fromViewController.navigationController?.popViewController(animated: false)
                                                        blurEffectView.removeFromSuperview()
                                                        }
                                                        )
        
     
    }
}

// Menu ----->>>> Settings
class SeguesToSettings: UIStoryboardSegue {
    override func perform() {
        animation()
    }
    private func animation(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        let originCenter = fromViewController.view.center
        
        toViewController.view.center = originCenter
        if let fromViewController = fromViewController as? BeginingViewController {
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0,
                                                           delay: 0.0,
                                                           options: [],
                                                           animations: {
                                                            fromViewController.blurEffectView.alpha = 0.0
            },
                                                           completion: {finished in
                                                            fromViewController.navigationController?.navigationBar.isHidden = false
                                                            fromViewController.blurEffectView.alpha = 1.0
                                                            fromViewController.navigationController?.pushViewController(toViewController,animated: false)
                                                            
            })
        }
        
    }
}

