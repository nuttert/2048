//
//  ItemConfiguration.swift
//  2048
//
//  Created by vlad on 30.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

protocol movingDelegateForCellBehavior : class
{
    typealias State = ItemConfiguration.State
    func nextAnimationStep(for item:ItemView,state:State,newX:Int,newY:Int,viewForDestroy:ItemView?)
}



class ItemConfiguration: UILabel {
typealias Point = Game.Point
    
    
   //Initialization
public func  initializeSystem(delegate:movingDelegateForCellBehavior,item:ItemView) {
        system = SystemForExterminator(item:item,delegate:delegate)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(animationStepHaveJustEnded(letter:)),
                                               name: Notification.notificationForDestination,
                                               object: nil)
    }
    
    //Controll amount of item
    static var amountOfMovingItem:Int = 0
    static var itemViewCounter:Set = {
        return Set(1...(Game.fieldSize*Game.fieldSize))
    }()
    lazy var identifire:Int = {
        let unique = ItemConfiguration.itemViewCounter.popFirst()
        assert(unique != nil)
        return unique!
    }()
    
    deinit{
        ItemConfiguration.itemViewCounter.insert(self.identifire)
    }
    
    //Controller paths of item
    struct SystemForExterminator{
        var didItStartAnimantions:Bool = false
        private var newCoordinate = [Point]()
        private var forDestroy = [ItemView?]()
        private var states = [State]()
        weak var delegate:movingDelegateForCellBehavior!
        weak var item:ItemView!
        init(item:ItemView,delegate:movingDelegateForCellBehavior){
            self.delegate = delegate
            self.item = item
        }
        mutating func push(new:Point,state:State,forDestroy:ItemView?){
            newCoordinate.append(new)
            states.append(state)
            self.forDestroy.append(forDestroy)
            if !didItStartAnimantions{
                didItStartAnimantions = true
                nextAnimationStep()
            }
            
        }
        mutating func pop()->(new:Point,state:State,forDestroy:ItemView?){
            return (newCoordinate.removeFirst(),states.removeFirst(),forDestroy.removeFirst())
        }
        func isEmpty()->Bool{
            return states.isEmpty
        }
        mutating func nextAnimationStep(){
            let newConfiguraters = pop()
            delegate.nextAnimationStep(for: item,
                                       state: newConfiguraters.state,
                                       newX: newConfiguraters.new.x,
                                       newY: newConfiguraters.new.y,
                                       viewForDestroy: newConfiguraters.forDestroy)
        }
    }
    
    
    var system : SystemForExterminator!
    
    //Destination controller
    @objc private func animationStepHaveJustEnded(letter:NSNotification){
        if letter.name == Notification.notificationForDestination{
            if thereIsNextStep{
                system.nextAnimationStep()
            }
        }
    }
    
    private var thereIsNextStep: Bool {
        if system.isEmpty(){
            system.didItStartAnimantions = false
        }
        return !system.isEmpty()
    }
    
    //STATE OF VIEW
    enum State{
        case exterminator,moving,def
    }
    var state : State = .def
    
}
