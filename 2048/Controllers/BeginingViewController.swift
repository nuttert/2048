//
//  ViewController.swift
//  2048
//
//  Created by vlad on 18.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

class BeginingViewController: VCLLoggingViewController {
    private    var backgroundImage:UIImage!
    private    var imageView: UIImageView!
               var blurEffectView:UIVisualEffectView!
    
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var menuTitle: UILabel!
    @IBAction func transitions(_ sender: Any) {
        guard let sender = sender as? UIButton else {return}
        for button in buttons{
            button.isHidden = true
        }
        switch AppConstants.menuButtonTags[sender.tag]{
        case  "settings":performSegue(withIdentifier: "to settings", sender: sender)
        case  "newGame" : performSegue(withIdentifier: "to main view", sender: sender)
        default:break
         
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        createBackgroundImage()
        createEffects()
        createConstraintsForBackground(label: imageView,
                                       adaptingRL: adaptImageRL,
                                       adaptingUB: adaptImageUB)
        createConstraintsForBackground(label: blurEffectView,
                                       adaptingRL: adaptImageRL,
                                       adaptingUB: adaptImageUB)
        adjustLabelText(label: menuTitle)
        for button in buttons{
        if let label = button.titleLabel{
            adjustLabelText(label: label)}
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         imageView.startAnimating()
    }
    
   
    
   //SEGUE
   @IBAction  func returnFromSegueActionu(_ unwindSegue:UIStoryboardSegue){}
  
    
    
    
//ADJUST BUTTON
    private func adjustLabelText(label:UILabel){
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.baselineAdjustment = .alignCenters
        label.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
   
    
    
//CREATE IMAGE
    private func createBackgroundImage(){
        imageView = UIImageView()
        self.view.insertSubview(imageView, at: 0)
        var arrayOfImages = [UIImage]()
        for index in 1...Constant.amountOfImagesForAnimation{
            if let image = UIImage(named: "backGround\(index)"){
                arrayOfImages += [image]
            }
        }
        imageView.contentMode = .scaleToFill
        imageView.animationImages = arrayOfImages
        imageView.animationDuration = 4.0
    }
    
    
//CREATE CONSTRAINTS
    private func createConstraintsForBackground(label:UIView,adaptingRL:CGFloat,adaptingUB:CGFloat){
        let mode = self.view.layoutMarginsGuide
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: mode.leftAnchor, constant: -adaptImageRL).isActive = true
        label.rightAnchor.constraint(equalTo: mode.rightAnchor, constant: adaptImageRL).isActive = true
        label.bottomAnchor.constraint(equalTo: mode.bottomAnchor, constant: adaptImageUB).isActive = true
        label.topAnchor.constraint(equalTo: mode.topAnchor, constant: -adaptImageUB).isActive = true
    }



//EFFECTS
    private func createEffects(){
        let bluerEffect = UIBlurEffect(style: .regular)
         blurEffectView = UIVisualEffectView(effect:bluerEffect)
        blurEffectView.frame = imageView.bounds
         imageView.addSubview(blurEffectView)
    }

}
extension BeginingViewController{
    struct Constant{
        static let amountOfImagesForAnimation = 4
        static let adaptImageForRightAndLeft:CGFloat = 10
        static let adaptImageForTopAndBottom:CGFloat = 10
        static let durationButtonAnimation:Double = 0.0
    }
    private var adaptImageRL:CGFloat{
        return self.view.bounds.width/Constant.adaptImageForRightAndLeft
    }
    private var adaptImageUB:CGFloat{
        return self.view.bounds.height/Constant.adaptImageForTopAndBottom
    }
}

