//
//  ModelHelper.swift
//  2048
//
//  Created by vlad on 30.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import Foundation

class Auxiliary {
    //HISTORY OF MOVING STRUCTURES
    struct Point:Hashable{
        //FOR HASHABLE
        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
        var x,y:Int
        init(_ x: Int,_ y:Int){
            self.x = x;self.y = y
        }
    }
    
    struct PairOfCoordinate{
        var previousPos,newPos:Int
        mutating func swapPosition(){
            previousPos = Game.fieldSize - previousPos - 1
            newPos = Game.fieldSize - newPos - 1
        }
        static func swapPositionInArray(_ array:inout [PairOfCoordinate]){
            let size = array.count
            if size > 0{
                for index in 0...array.count-1{
                    array[index].swapPosition()
                }
            }
        }
    }
    struct MovingSystem{
        enum DurationAround:Hashable{
            case x(Int)
            case y(Int)
            
        }
        private(set) var movingRelateXorY = [DurationAround:[PairOfCoordinate]]()
        var wasMovings:Bool = false
        mutating func addMoving(durationAround: DurationAround,historyOfMoving: [PairOfCoordinate]){
            movingRelateXorY.updateValue(historyOfMoving,
                                         forKey: durationAround)
        }
        mutating func updateMovingSystem(){
            movingRelateXorY.removeAll()
            wasMovings = false
        }
    }
    
    
    
    //GET/SET POSITION AND RAW/COLUMN OF FIELD
    func getPositionFromNumber (number:Int)->Point{
        let x = number % fieldSize
        let y = number / fieldSize
        return Point(x,y)
    }
    func getNumberFromPosition (position: (Int,Int))->Int{
        return position.0*fieldSize+position.1
    }
}



extension Auxiliary{
      var fieldSize :Int{
        return Game.fieldSize
    }
}


