//
//  ItemBehavior.swift
//  2048
//
//  Created by vlad on 19.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit
protocol BehaviorsDeck: class
{
    func getMiddleOfCellInSuperview(byX:Int,byY:Int)->CGPoint
}

protocol InitializeController: class
{
    func initializeGame()
    func updateField()
}


class Behaviors: UIDynamicBehavior,movingDelegateForCellBehavior {
    
    func nextAnimationStep(for item:ItemView,state:State,newX: Int, newY: Int, viewForDestroy: ItemView?) {
        let destination = deck.getMiddleOfCellInSuperview(byX: newX, byY: newY)
        let vectorPath = CGPoint(x: destination.x - item.center.x,
                                 y: destination.y - item.center.y)
        
        let lenghtPath = sqrt(pow(vectorPath.x,2) + pow(vectorPath.y,2))
        let time = Double(lenghtPath * 1/AppConstants.speedCofficient)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: time,
                                                       delay: 0.0,
                                                       options: [],
                                                       animations: { [weak item] in
                                                        item?.center = destination
            }, completion: {[weak self] finish in
                    if state == .exterminator {                             //DESTROYER || MOVING
                        viewForDestroy?.removeFromSuperview()
                        item.updateItemNumber()
                        Animations.animationWithScale(item, withScaled: AppConstants.scaleForAnimation)
                    }
                    ItemView.amountOfMovingItem -= 1
                    if ItemView.amountOfMovingItem == 0{
                        self?.controllerForInitialize.initializeGame()
                    }
            self?.controllerForInitialize.updateField()
            NotificationCenter.default.post(name: Notification.notificationForDestination, object: nil)
        })
    }
    

   
 

    init(deck:BehaviorsDeck,controller:InitializeController) {
        self.deck = deck
        self.controllerForInitialize = controller
    }
    
    weak var deck:BehaviorsDeck!
    weak var controllerForInitialize:InitializeController!
    
}

