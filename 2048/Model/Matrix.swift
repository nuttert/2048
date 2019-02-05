//
//  Matrix.swift
//  2048
//
//  Created by vlad on 30.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import Foundation
extension Game{
    internal struct Matrix<T:Equatable> :CustomStringConvertible{
        var description: String{
            var stringMatrix = ""
            for x in 0...columnCount-1{
                for y in 0...rowCount-1{
                    if let char = matrix[x][y] as? Int64{
                    stringMatrix += String(char)
                    }else{
                        stringMatrix += String(0)
                    }
                    stringMatrix += " "
                }
                stringMatrix += "\n"
            }
            return stringMatrix
        }
        
    private var matrix: [[T]]
            var amountOfElements = 0
    private var nilValue:T?
    init(rows: Int, columns: Int, nilValue: T){
        self.init(Matrix: [[T]](repeating: [T](repeating: nilValue, count: columns), count: rows))
        amountOfElements = 0
        self.nilValue = nilValue
    }
    
    private init(Matrix: [[T]]){
        self.matrix = Matrix
    }
    
    init(arrayLiteral elements: [T]...) {
        if let count = elements.first?.count {
            for row in elements {
                if row.count != count {
                    fatalError("Matrix must have same number of rows and columns")
                }
            }
        }
        self.init(Matrix: elements)
    }
    
    //ACCESS
    
    subscript(row: Int, column: Int) -> T {
        get {
            return matrix[row][column]
        }
        set {
            matrix[row][column] = newValue
        }
    }
    //ROW
    subscript(_ y:Int)-> [T]{
        get {
            var row = [T]()
            for x in 0...rowCount-1{
                row.append(matrix[x][y])
            }
            return row
        }
        set {
            for x in 0...rowCount-1{
                matrix[x][y] = newValue[x]
            }
        }
    }
    //COLUMN
    subscript(column x: Int) -> [T] {
        get {
            return matrix[x]
        }
        set {
            matrix[x] = newValue
        }
    }
    
    var dimensions: (rows: Int, columns: Int) {
        get {
            return (matrix.count, matrix.first?.count ?? 0)
        }
    }
    
    var rowCount: Int {
        get {
            return matrix.count
        }
    }
    
    var columnCount: Int {
        get {
            return matrix.first?.count ?? 0
        }
    }
    
    var count: Int {
        get {
            return rowCount * columnCount
        }
    }
    
    //GET POSITION OF UNVAILABLE CELLS
    var notAvailabelCells:[Int]{
        var cells = [Int]()
        for x in 0...columnCount-1{
            for y in 0...rowCount-1{
                if matrix[x][y] != nilValue{
                    cells.append(x*Game.fieldSize+y)
                }
            }
        }
        return cells
    }
    
    
}
    





internal struct Vector<T:Equatable> {
    private var vector: [T]
    private var nilValue:T!
    init(lenght: Int, nilValue: T){
        self.vector = [T].init(repeating: nilValue, count: lenght)
        self.nilValue = nilValue
    }
    
    private init(vector: [T]){
        self.vector = vector
    }
    
  
    
    //ACCESS
    
    subscript(x: Int) -> T {
        get {
            return vector[x]
        }
        set {
            vector[x] = newValue
        }
    }

    var count: Int {
        get{
            return vector.count
            }

        }
    }
}


