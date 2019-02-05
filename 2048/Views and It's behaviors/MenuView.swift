//
//  MenuView.swift
//  2048
//
//  Created by vlad on 20.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

class MenuView: UIView {
    private let gameNameView = UILabel()
    private let scoreView =  UILabel()
            var menuButton = UIButton()
    private var score:Int64 = 0{
        didSet{
            
           configureScoreLabel()
        }
    }
   
    override func draw(_ rect: CGRect) {
        gameNameView.backgroundColor = UIColor.clear
        addSubview(gameNameView)
        
        scoreView.backgroundColor = UIColor.clear
        addSubview(scoreView)
        
        menuButton.backgroundColor = UIColor.clear
        addSubview(menuButton)
        
  
        MenuView.configureLabel(label: gameNameView,
                       text: String(2048),
                       color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                       fontSize: AppConstants.FontSizeForMenu(bounds: gameNameView.bounds))
        configureScoreLabel()
        
        MenuView.configureButton(button: menuButton,
                        text: "Menu",
                        color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),
                        fontSize: AppConstants.FontSizeForButtonsMenu(bounds: menuButton.bounds))
        
        AppConstants.roundRectWithColor(bounds: scoreView.frame, color: #colorLiteral(red: 0.7417411208, green: 0.6848828197, blue: 0.635558784, alpha: 1))
        AppConstants.roundRectWithColor(bounds: gameNameView.frame, color: #colorLiteral(red: 0.9243300557, green: 0.7695215344, blue: 0.002081802348, alpha: 1))
        AppConstants.roundRectWithColor(bounds: menuButton.frame, color: #colorLiteral(red: 0.7417411208, green: 0.6848828197, blue: 0.635558784, alpha: 1))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gameNameView.frame = frameForGameName()
        scoreView.frame = frameForScore()
        menuButton.frame = frameForButtonMenu()
    }
    
    
    //UPDATING
    func updateMenu(score:Int64){
        self.score = score
    }
}
   





extension MenuView{
    //TEXT
     static func getAttributedString(text:String,color:UIColor,fontSize:CGFloat)->NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let color =  color
       return NSAttributedString(string: text, attributes: [.paragraphStyle : paragraphStyle,
                                                      .font:font,
                                                      .foregroundColor:color])
    }
    
   static  func configureLabel(label :UILabel,text:String,color:UIColor,fontSize:CGFloat){
        
        label.attributedText = getAttributedString(text:text,
                                                   color:color,
                                                   fontSize:fontSize)}
    
    static  func configureButton(button:UIButton,text:String,color:UIColor,fontSize:CGFloat){
        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]{
            button.setAttributedTitle(getAttributedString(text: text,
                                                          color: color,
                                                          fontSize: fontSize),for: state)
        }
    }
    private func configureScoreLabel(){
        scoreView.numberOfLines = 2
        MenuView.configureLabel(label: scoreView,
                       text: String("Score:"+"\n"+"\(score)"),
        color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
        fontSize: AppConstants.FontSizeForMenu(bounds: scoreView.bounds))
    }
   
}




extension MenuView{
    //FRAME
    private func frameForGameName()->CGRect{
        return CGRect(origin: CGPoint(x: 0.0, y: 0.0),
                      size: CGSize(width: self.bounds.height, height: self.bounds.height))
    }
    private func frameForScore()->CGRect{
        let scoreOrigin = CGPoint(x:gameNameView.bounds.width + AppConstants.lengthSeparator,y:0.0)
        return CGRect(origin: scoreOrigin,
                      size: CGSize(width: gameNameView.bounds.width - AppConstants.lengthSeparator - AppConstants.heightButtonMenu,
                                   height: self.bounds.height - AppConstants.lengthSeparator - AppConstants.heightButtonMenu))
    }
    private func frameForButtonMenu()->CGRect{
        return CGRect(x: gameNameView.bounds.width + AppConstants.lengthSeparator,
                      y: scoreView.bounds.height + AppConstants.lengthSeparator,
                      width: scoreView.bounds.width,
                      height: gameNameView.bounds.height - scoreView.bounds.height - AppConstants.lengthSeparator)
    }

}

