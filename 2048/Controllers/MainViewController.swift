//
//  MainViewController.swift
//  2048
//
//  Created by vlad on 18.08.2018.
//  Copyright © 2018 vlad. All rights reserved.
//

import UIKit

class MainViewController: VCLLoggingViewController,InitializeController {
  typealias Point = Game.Point
    var fieldSize:Int{
        return AppConstants.amountOfCell
    }
    
    //ANIMATIONS
    private  var cellBehavior : Behaviors!
    //GAME FIELD
    private var field =  Game()
    //VIEWS
    private lazy var menu: MenuView = {
        let menuView = MenuView(frame: CGRect(x: 0.0+offsetFromBounds*AppConstants.cofficientCoordinateYMenuView,
                                              y: 0.0+offsetFromBounds*AppConstants.cofficientCoordinateYMenuView,
                                              width: widthAndHeightDeck,
                                              height: self.view.bounds.height/6))
        menuView.backgroundColor = UIColor.clear
        return menuView
    }()
    
   private(set) lazy var deck: DeckView = {
        let  deck = DeckView(frame: CGRect(origin: self.view.bounds.origin,
                                           size: CGSize(width: widthAndHeightDeck,
                                                        height: widthAndHeightDeck)))
        deck.backgroundColor = UIColor.clear
        return deck
    }()
    
    private lazy var viewItems : [[ItemView?]]! = {
        var viewItems = [[ItemView?]]()
        for _ in 1...fieldSize{
            viewItems.append([ItemView?].init(repeating: nil, count: fieldSize))
        }
        return viewItems
    }()
    private var constrainsForDeck : (right:NSLayoutConstraint,center:NSLayoutConstraint)!
    
    
    //LIFECICLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(deck)
        self.view.addSubview(menu)
        cellBehavior = Behaviors(deck: deck, controller: self)
        initializeGame()
        createSwipeGestures()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createPortraitConstraintsForDeck()
        createTarget(button: menu.menuButton)
    }
    
    
}








    extension MainViewController{
    
    //INITIALIZER and updater
      func initializeGame(){
        for _ in 1...(AppConstants.amountOfCell > 4 ? AppConstants.amountOfCell-1:2){
                setNewRandomItem()
        }
    }
    
    private func setNewRandomItem(){
        if let randomNumber = (fieldSize.pow(deg: 2)).arc4random(sequence: field.notAvailableCells){
            let position = field.getPositionFromNumber(number: randomNumber)
            let x = position.x
            let y = position.y
            field[x,y] = AppConstants.gameNumber
            let view = ItemView(frame: deck.getCellRect(byX: x, byY: y),delegate:cellBehavior)
            viewItems[x][y] = view
        
            view.alpha = 0
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            deck.addSubview(view)
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                           delay: 0.3,
                                                           options: [],
                                                           animations: {[weak view] in view?.alpha = 1;view?.transform = .identity})
        }
    }
    func updateField(){
        if field.gameOver{
            let alert = UIAlertController(title: "Game Over",
                                          message: "Do you want restart?",
                                          preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes",
                                    style: .default,
                                    handler: {[weak self] action in
                                        guard let guardSelf = self else {return}
                                        guardSelf.field.restartModel()
                                        guardSelf.restartViews()
                                        guardSelf.field.gameOver = false
                                        guardSelf.initializeGame()
                                        guardSelf.menu.updateMenu(score: guardSelf.field.score)
                                        })
            let no = UIAlertAction(title: "No",
                                   style: .default,
                                   handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
        }
        menu.updateMenu(score: field.score)
    }
    private func restartViews(){
        for x in viewItems.indices {
            for y in viewItems.indices{
                if let view = viewItems[x][y] {
                    view.removeFromSuperview()
                    viewItems[x][y] = nil
                }
            }
        }
    }
}






extension MainViewController{
    //GESTURES
    @objc private func swipping(_ sender:UISwipeGestureRecognizer){
        func brainOfMoving(prevX:Int,prevY:Int,newX:Int,newY:Int){
            guard  let movingCell = viewItems[prevX][prevY] else {assert(false);return}
            
            if let standingView = viewItems[newX][newY]{
                movingCell.system.push(new:Point(newX,newY),
                                       state:.exterminator,
                                       forDestroy: standingView)
            }else{
                movingCell.system.push(new:Point(newX,newY),
                                       state:.moving,
                                       forDestroy: nil)
            }
            
            
            viewItems[newX][newY] = viewItems[prevX][prevY]
            viewItems[prevX][prevY] = nil
            ItemView.amountOfMovingItem += 1
        }
        if ItemView.amountOfMovingItem != 0 {return}
        if field.gameOver {updateField()}
        if sender.state == .ended{
            switch sender.direction{
            case .right: field.getDirection(direct: .right)
            case .left:  field.getDirection(direct: .left)
            case .up:    field.getDirection(direct: .up)
            case .down:  field.getDirection(direct: .bottom)
            default:
                break
            }
        }
        for (durationWithCoordinate,segues) in field.movingSystem.movingRelateXorY{
            switch durationWithCoordinate{
            case .x(let x):
                for segue in segues{
                    let newY = segue.newPos
                    let prevY = segue.previousPos
                    brainOfMoving(prevX: x,
                                  prevY: prevY,
                                  newX: x,
                                  newY: newY)
                }
            case .y(let y):
                for segue in segues{
                    let newX = segue.newPos
                    let prevX = segue.previousPos
                    brainOfMoving(prevX: prevX,
                                  prevY: y,
                                  newX: newX,
                                  newY: y)
                }
            }
        }
        field.updateMovingSystem()
    }
    
    
    private func createSwipeGestures(){
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipping(_:)))
        rightSwipe.direction = .right
        deck.addGestureRecognizer(rightSwipe)
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipping(_:)))
        leftSwipe.direction = .left
        deck.addGestureRecognizer(leftSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipping(_:)))
        upSwipe.direction = .up
        deck.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipping(_:)))
        downSwipe.direction = .down
        deck.addGestureRecognizer(downSwipe)
    }
    
    //BUTTONS
    @objc private func tapMenu(_ sender:UIButton){
        sender.isEnabled = false
        performSegue(withIdentifier: "back to menu", sender: sender)
    }
    private func createTarget(button:UIButton){
        button.addTarget(self, action: #selector(tapMenu(_:)), for: UIControl.Event.allTouchEvents)
    }
}









extension MainViewController{
     //CREATE CONSTRAINTS FOR VIEWS
    private func createPortraitConstraintsForDeck(){
        commonConstraintsForDeck()
        constrainsForDeck.right.isActive = false
        constrainsForDeck.center.isActive = true
    }
    
    private func createLandscapeConstraintsForDeck(){
        commonConstraintsForDeck()
        constrainsForDeck.center.isActive = false
        constrainsForDeck.right.isActive = true
    }
    
    private func commonConstraintsForDeck(){
        if deck.constraints.isEmpty{
            deck.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            deck.translatesAutoresizingMaskIntoConstraints = false
            deck.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -offsetFromBounds).isActive = true
            deck.heightAnchor.constraint(equalTo: deck.widthAnchor, multiplier: 1.0).isActive = true
            deck.widthAnchor.constraint(equalToConstant: deck.bounds.width ).isActive = true
            constrainsForDeck = (right:deck.rightAnchor.constraint(equalTo: self.view.rightAnchor,
                                                                   constant: -offsetFromBounds*AppConstants.cofficientCoordinateYMenuView),
                                center:deck.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        }
    }
    
  
    
}




extension MainViewController{
    //SIZES FOR VIEWS
    var widthView:CGFloat {
        return min(self.view.bounds.width,self.view.bounds.height)
    }
    var offsetFromBounds:CGFloat {
        return widthView/AppConstants.offsetFromBoundsCofficient
        
    }
    var widthAndHeightDeck:CGFloat{
            return widthView-offsetFromBounds*2
        }
    
    //RECTANGLE FOR CELL
    private func rectForItem(byX:Int,byY:Int)->CGRect{
        var rect = deck.getCellRect(byX: byX, byY: byY)
        rect.size.width *= AppConstants.increaseItemBy
        rect.size.height *= AppConstants.increaseItemBy
        return rect
    }
}



extension MainViewController{
    //SEGUES AND TRANSITIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BeginingViewController{
            for button in vc.buttons{
            button.isHidden = false
            }
        }
        field.restartModel()
        self.restartViews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait{
            createPortraitConstraintsForDeck()
        }else{
            createLandscapeConstraintsForDeck()
        }
    }
}


