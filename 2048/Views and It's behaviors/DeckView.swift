//
//  DeckView.swift
//  2048
//
//  Created by vlad on 18.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit
class DeckView: UIView{
    static var amountOfCells:Int {
        let amount = AppConstants.amountOfCell
        assert(amount>0)
        return amount 
    }
   
    deinit{
        print(1)
    }
    
    //SIZE OF CELL AND SEPARATOR
    private  var widthAndHighOfSeparator:CGFloat  {
        let widthView = self.bounds.width
        assert(widthView != 0)
        let amount = DeckView.amountOfCells == 1 ? 2:DeckView.amountOfCells
        return widthView/(CGFloat(amount*amount)*AppConstants.separatorCofficient)}
    
    private   var widthAndHighOfCell:CGFloat {let widthView = self.bounds.width
        return (widthView-widthAndHighOfSeparator*CGFloat(DeckView.amountOfCells+1))/CGFloat(DeckView.amountOfCells)}
   
    override func draw(_ rect: CGRect) {
        //ROUNDING FOR DECK
        let roundRect = AppConstants.extractedFunc(bounds: bounds)
        #colorLiteral(red: 0.7417411208, green: 0.6848828197, blue: 0.635558784, alpha: 1).setStroke()
        #colorLiteral(red: 0.7417411208, green: 0.6848828197, blue: 0.635558784, alpha: 1).setFill()
        roundRect.stroke()
        roundRect.fill()
        roundRect.addClip()
        //CREATING round cell
        for X in 0...DeckView.amountOfCells-1{
            for Y in 0...DeckView.amountOfCells-1{
                createCell(byX: X, byY: Y)
            }
        }
        
    }
    //private
    //CREATING CELL
    private func createCell(byX X:Int, byY Y: Int){
        AppConstants.roundRectWithColor(bounds: getCellRect(byX: X, byY: Y),
                                        color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.6542433647))
    }
}





extension DeckView:BehaviorsDeck 
{
 //public
    //GETTING SOME POSITION AND COORDINATE OF CELLS
    func getCellRect( byX: Int, byY: Int)->CGRect{
        assert(byX<Game.fieldSize && byY<Game.fieldSize)
        return CGRect(x: widthAndHighOfSeparator+(widthAndHighOfCell+widthAndHighOfSeparator)*CGFloat(byX),
                      y: widthAndHighOfSeparator+(widthAndHighOfCell+widthAndHighOfSeparator)*CGFloat(byY),
                      width: widthAndHighOfCell,
                      height: widthAndHighOfCell)
       
    }
   
    func getMiddleOfCellInSuperview(byX:Int,byY:Int)->CGPoint{
        assert(byX<Game.fieldSize && byY<Game.fieldSize)
        let superview = self.superview != nil ? self.superview! : self
        let x = widthAndHighOfSeparator+(widthAndHighOfCell+widthAndHighOfSeparator)*CGFloat(byX)+widthAndHighOfCell/2 + superview.bounds.origin.x
        let y = widthAndHighOfSeparator+(widthAndHighOfCell+widthAndHighOfSeparator)*CGFloat(byY)+widthAndHighOfCell/2 + superview.bounds.origin.y
        return CGPoint(x: x ,y: y)
    }
}
