//
//  File.swift
//  2048
//
//  Created by vlad on 18.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import Foundation
class Game:Auxiliary{
typealias MovingSystem = Auxiliary.MovingSystem
    
     private(set)  var movingSystem = MovingSystem()
    
    
    public func updateMovingSystem(){
        movingSystem.updateMovingSystem()
    }
    
    
    //FIELD OF GAME
    private(set) var field = Matrix<Int64?>(rows: fieldSize,
                                            columns: fieldSize,
                                            nilValue: nil)
    
    private(set) var score : Int64 = 0

    static var fieldSize:Int {
        return AppConstants.amountOfCell
    }
    
    private var amountOfElements:Int{
        get{
            return field.amountOfElements
        }
        set{
            field.amountOfElements = newValue
        }
    }
    
    var  gameOver = false
   
    //SORT FIELD AFTER SNAPPING
    func getDirection(direct:direction){
        switch direct {
        case .up:
            for x in 0...Game.fieldSize-1{
                let sortResult = rawSort(raw: field[x])
                field[x] = sortResult.sortedVector
                movingSystem.addMoving(durationAround: MovingSystem.DurationAround.x(x),
                                       historyOfMoving: sortResult.moveHystory)
                
            }
        case.bottom:
            for x in 0...Game.fieldSize-1{
                var sortResult = rawSort(raw: field[x].reversed())
                field[x] = sortResult.sortedVector.reversed()
                PairOfCoordinate.swapPositionInArray(&sortResult.moveHystory)
                movingSystem.addMoving(durationAround: MovingSystem.DurationAround.x(x),
                                       historyOfMoving: sortResult.moveHystory)
            }
        case.left:
            for y in 0...Game.fieldSize-1{
                let sortResult = rawSort(raw: field[column:y])
                let sortedRaw = sortResult.sortedVector
                field[column:y] = sortedRaw
                movingSystem.addMoving(durationAround: MovingSystem.DurationAround.y(y),
                                       historyOfMoving: sortResult.moveHystory)
            }
        case.right:
            for y in 0...Game.fieldSize-1{
                var sortResult = rawSort(raw: field[column:y].reversed())
                let sortedRaw = sortResult.sortedVector.reversed() as [Int64?]
                field[column:y] = sortedRaw
                PairOfCoordinate.swapPositionInArray(&sortResult.moveHystory)
                
                movingSystem.addMoving(durationAround: MovingSystem.DurationAround.y(y),
                                       historyOfMoving: sortResult.moveHystory)
            }
            
        }
        checkGameOver()
        
    }
}








extension Game{
    //SORT RAW OR COLUMNS OF FIELD AFTER SNAPPING.GET SORTED RAW WITH HYSTORY OF MOVING.
    private func rawSort(raw:[Int64?])->(sortedVector:[Int64?],moveHystory:[PairOfCoordinate]){
        var raw = raw
        let rawSize = raw.count - 1
        var nilCell:Int?
        var dynamicIndex = 0
        var positionSystem = [PairOfCoordinate]()
        var previousPos,newPos:Int!
        func subSort(){
            dynamicIndex = 0
            for _ in 0...rawSize{
                nilCell = nil
                for index in dynamicIndex...rawSize{
                    if (raw[index] == nil) && (nilCell == nil){ nilCell = index;newPos = index}
                    else if  (nilCell != nil) && (raw[index] != nil){
                        previousPos = index
                        positionSystem.append(PairOfCoordinate(previousPos:previousPos!,
                                                               newPos:newPos!))
                        raw[nilCell!] = raw[index]
                        raw[index] = nil
                        nilCell = nil
                        dynamicIndex += 1
                        break
                    }
                }
            }
        }
        subSort()
        for index in stride(from: 0, to: rawSize, by: 1){
            if raw[index] == raw[index+1] && raw[index] != nil{
                raw[index]! *= 2
                raw[index+1] = nil
                score += raw[index]!
                amountOfElements -= 1
                positionSystem.append(PairOfCoordinate(previousPos:index+1,
                                                       newPos:index))
                movingSystem.wasMovings = true
            }
        }
        subSort()
        return (raw,positionSystem)
    }
}





extension Game{
    //GAME OVER
    private func checkGameOver(){
        if amountOfElements == fieldSize.pow(deg: 2){
            for x in 0...fieldSize-1 {
                for y in 0...fieldSize-1{
                    if field[column:x].indices.contains(y+1),field[x,y+1] == field[x,y] {return}
                    if field[y].indices.contains(x+1),field[x+1,y] == field[x,y] {return}
                }
            }
            gameOver = true
        }
    }
    
    func restartModel(){
        self.field = Matrix<Int64?>(rows: Game.fieldSize,
                                    columns: fieldSize,
                                    nilValue: nil)
        score = 0
        movingSystem.updateMovingSystem()
    }
    
    
    //DIRECTION OF SNAP
    enum direction{
        case right,left,up,bottom
    }
    
    var notAvailableCells:[Int]{
        return field.notAvailabelCells
    }
    
    
}






extension Game{
    //ACCESS
    subscript(row: Int, column: Int) -> Int64? {
        get {
            return field[row][column]
        }
        set {
            field[row][column] = newValue
            amountOfElements += 1
        }
    }
    //ROW
    subscript(_ y:Int)-> [Int64?]{
        get {
            var row = [Int64?]()
            for x in 0...field.rowCount-1{
                row.append(field[x][y])
            }
            return row
        }
        set {
            for x in 0...field.rowCount-1{
                field[x][y] = newValue[x]
            }
        }
    }
    //COLUMN
    subscript(column x: Int) -> [Int64?] {
        get {
            return field[x]
        }
        set {
            field[x] = newValue
        }
    }
}
