//
//  Settings.swift
//  2048
//
//  Created by vlad on 30.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    
    @IBOutlet var result: [UILabel]!
    @IBOutlet weak var fieldSizeText: UITextField!
    @IBOutlet var backgroundView: [UIView]!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var stepperOutlet: UIStepper!
    private    var imageView: UIImageView!
    
    
    @IBAction func stepper(_ sender: UIStepper) {
        AppConstants.amountOfCell = Int(sender.value)
        for label in result{
            if AppConstants.settingsLabelTags[label.tag] == "size"{
                label.text = String(AppConstants.amountOfCell)+"x"+String(AppConstants.amountOfCell)
            }
        }
    }
   
    @IBAction func slider(_ sender: UISlider) {
        AppConstants.speedCofficient = CGFloat(sender.value)
        for label in result{
            if AppConstants.settingsLabelTags[label.tag] == "speed"{
            label.text = String(Int(sender.value/(sender.maximumValue)*100))+" %"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         if let backgroundView = tableView.backgroundView{
           configureBackgroundView(view: backgroundView)
         }else{
            let view = UIView(frame: tableView.bounds)
            tableView.backgroundView = view
            configureBackgroundView(view: view)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeSettingLabel()
        adjustLabelText(label: fieldSizeText)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performSegue(withIdentifier: "fromSettingsToMenu", sender: nil)
    }
   
  
    private func configureBackgroundView(view:UIView){
            imageView = UIImageView(frame: (view.bounds))
            view.insertSubview(imageView, at: 0)
            var imageArray = [UIImage]()
        for index in 1...3{
            if let image = UIImage(named: "settingBackground\(index)"){
                imageArray.append(image)
            }
        }
            imageView.contentMode = .scaleToFill
            imageView.animationImages = imageArray
            imageView.animationDuration = 4.0
    }
    private func initializeSettingLabel(){
        for label in result{
            switch AppConstants.settingsLabelTags[label.tag]{
            case "speed":
                label.text = String(Int(Float(AppConstants.speedCofficient)/(sliderOutlet.maximumValue)*100))+" %"
                sliderOutlet.value = Float(AppConstants.speedCofficient)
            case "size":
                label.text = String(AppConstants.amountOfCell)+"x"+String(AppConstants.amountOfCell)
                stepperOutlet.value = Double(AppConstants.amountOfCell)
            case "gameNumber":
                label.text = String(AppConstants.GameNumber)
            default:break
            }
        }
    }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BeginingViewController{
            for button in vc.buttons{
                button.isHidden = false
            }
        }
        navigationController?.navigationBar.isHidden = true
    }
    private func adjustLabelText(label:UITextField){
        label.adjustsFontSizeToFitWidth = true
        label.minimumFontSize = 0.2
        label.textAlignment = .center
        label.attributedText = MenuView.getAttributedString(text: label.text ?? "",
                                     color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),
                                     fontSize: 23.0)
    }

}







extension SettingsViewController : UITextFieldDelegate{
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        AppConstants.GameNumber = Int(textField.text ?? "0") ?? 0
        for label in result{
            if AppConstants.settingsLabelTags[label.tag] == "gameNumber"{
                label.text = textField.text
            }
        }
           return true
    }
}
