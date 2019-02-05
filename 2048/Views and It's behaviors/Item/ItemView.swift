//
//  ItemView.swift
//  2048
//
//  Created by vlad on 18.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit




class ItemView: ItemConfiguration {
    
    //Number
    var number:Int64 = AppConstants.gameNumber {
        didSet{
            assert(number % AppConstants.gameNumber == 0 && number > 0)
            if oldValue != number{
              colorLevel += colorLevelForBegining/step
              step *= 2
              setNeedsDisplay()
            }
        }
    }

    
    //COLORS
    private let colorConst:CGFloat = 255
    private var colorLevelForBegining:CGFloat{
        return colorConst
    }
    private var colorLevel:CGFloat = 0{
        didSet{
            assert(colorLevel >= 0 && colorLevel <= colorConst)
        }
    }
    private var step:CGFloat = 2.5
    private func colorFunction(x:CGFloat)->CGFloat{
        assert(x>=0 && x<=1)
        return sqrt(1-(x-1)*(x-1))
    }
    
    
     init(frame: CGRect, delegate: movingDelegateForCellBehavior) {
        super.init(frame: frame)
        initializeSystem(delegate:delegate,item:self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        AppConstants.roundRectWithColor(bounds: self.bounds,
                                     color: {()->UIColor in
                                        let red:CGFloat = 1.0
                                        let blue:CGFloat = (colorConst - colorLevel)/255
                                        let green:CGFloat = colorFunction(x: blue)
                                        return UIColor(red: red,
                                                       green: green ,
                                                       blue: blue,
                                                       alpha: 1.0)}() )
        
        configureLabel(label: self)
        drawText(in: self.bounds)
    }
    
    
    
    //CREATE AND SET TEXT
    private func configureLabel(label :UILabel){
        label.attributedText = getAttributedString()
    }
    private func getAttributedString()->NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(AppConstants.FontSizeForCell(view:self))
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.allowsDefaultTighteningForTruncation = true
        let red:CGFloat = (0.0 + colorLevel)/colorConst,green = (0.0 + colorLevel)/colorConst,blue = (0.0  + colorLevel)/colorConst
        let color =  UIColor(red:red,
                             green: green,
                             blue: blue,
                             alpha: 1.0)
        return NSAttributedString(string: String(number), attributes: [.paragraphStyle : paragraphStyle,
                                                                       .font:font,
                                                                       .foregroundColor:color])
    }
    
    

    //UPDATE POINTS AND TEXT
    public func updateItemNumber(){
        self.number *= 2
    }

}
