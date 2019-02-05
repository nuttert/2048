//
//  SizeRatio.swift
//  2048
//
//  Created by vlad on 19.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import Foundation
import UIKit


extension Int{
    func pow(deg:Int)->Int{
        return Int(Foundation.pow(Float(self), Float(deg)))
    }
}
extension Int{
    public var arc4random:Int
    {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(abs(self))))
        }
        else if self < 0
        {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else
        {
            return 0
        }
    }
    public func arc4random(sequence: Array<Int>)->Int?{
        
        var availableNumbers = [Int]()
        for i in 0...self-1{
            availableNumbers.append(i)
        }
        for item in sequence{
            assert(item<self)
            for i in 0...(availableNumbers.count-1){
                if availableNumbers[i] == item{
                    availableNumbers.remove(at: i)
                    break
                }
            }
        }
        let randomIndex = availableNumbers.count.arc4random
        return availableNumbers.count>0 ? availableNumbers[randomIndex] : nil
    }
}

struct AppConstants{
    static var amountOfCell = 4
    static var GameNumber = 2
    static var speedCofficient = CGFloat(4150.0) // 450 - 650 - averge
    static let scaleForAnimation:CGFloat = 1.09
    
    static let offsetOriginInternalFrame:CGFloat = 1.2
    static let offsetSizeInternalFrame:CGFloat = 3
    static let increaseItemBy:CGFloat = 0.9
    static let gameNumber:Int64 = Int64(AppConstants.GameNumber)
    
    static let cofficientFontSizeForCell:CGFloat = 0.9
    static let cofficientFontSizeForMenu:CGFloat = 0.3
    static let cofficientFontSizeForButtonsMenu:CGFloat = 0.9
    
    static let lengthSeparator:CGFloat = 10
    static let heightButtonMenu:CGFloat = 20
    static let cofficientCoordinateYMenuView:CGFloat = 3
    
    static let cornerRadiusToBoundsHeight:CGFloat = 0.06
    static let offsetFromBoundsCofficient:CGFloat = 35
    static let relativeFontConstant:CGFloat = 0.046
    static let separatorCofficient:CGFloat = 2
    
    static let notificationForDestination = "destinationIsReached"
    static let menuButtonTags = [1:"newGame",
                             2:"settings"]
    
    static let settingsLabelTags = [1:"speed",
                                 2:"size",
                                 3:"gameNumber"]
    
    static func extractedFunc(bounds:CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: AppConstants.cornerRadius(bounds: bounds))
    }
    static func roundRectWithColor(bounds: CGRect,color:UIColor){
        let roundRect = AppConstants.extractedFunc(bounds: bounds)
        color.setStroke()
        color.setFill()
        roundRect.stroke()
        roundRect.fill()
    }
    
    static func cornerRadius(bounds:CGRect)->CGFloat{
        return  bounds.size.height * AppConstants.cornerRadiusToBoundsHeight
    }
    
    static func FontSizeForCell(view:ItemView)-> CGFloat{
        return view.bounds.size.height * AppConstants.cofficientFontSizeForCell/(AppConstants.getCountsOfDigitsCofficient(view.number))
    }
    static func FontSizeForMenu(bounds:CGRect)-> CGFloat{
        return bounds.size.height * AppConstants.cofficientFontSizeForMenu
    }
    static func FontSizeForButtonsMenu(bounds:CGRect)->CGFloat{
        return bounds.size.height * AppConstants.cofficientFontSizeForButtonsMenu
    }
    static func getCountsOfDigitsCofficient(_ number:Int64)->CGFloat {
        var number = number
        var count = (number == 0) ? 1 : 0
        while (number != 0) {
            count += 1
            number /= 10
        }
        return count == 1 ? 1 :CGFloat(count)*0.6
    }
    
}



public extension Notification{
    static var notificationForDestination : NSNotification.Name{
        return .init(AppConstants.notificationForDestination)
    }
}





