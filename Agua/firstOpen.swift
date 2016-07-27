//
//  firstOpen.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/16/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import GoogleMobileAds
import FBSDKCoreKit
import FBSDKLoginKit
import Instructions
/*

class firstOpen: UIViewController, CoachMarksControllerDataSource {

    
    var coachMarksController: CoachMarksController?
    
    let titleText = "This is the main page where you'll get your points. Start by locking your screen here."
    let timerText = "This shows you how much time is left until you earn your next point."
    let pointsText = "You can see how many points you've earned by looking here or on the navigation bar next to the water drop."
    let adText = "You don't have to wait 45 minutes to get your points, click here to reduce the amount of time needed to get your points by 5 minutes."
    let menuText = "You can spend and earn more points by clicking here or swiping your screen to the left to access the rest of the app's features."
    
    let nextButtonText = "Ok!"
    
    
    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 5
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }
        case 1:
            return coachMarksController.coachMarkForView(self.timerDisplay)
        case 2:
            return coachMarksController.coachMarkForView(self.pointsDisplay)
        case 3:
            return coachMarksController.coachMarkForView(self.ADButton)
        case 4:
            return coachMarksController.coachMarkForView(self.menuDisplay)
        default:
            return coachMarksController.coachMarkForView()
        }
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.titleText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.timerText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.pointsText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = self.adText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.menuText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
            self.dismissViewControllerAnimated(true , completion: {})
        default:
            break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstAppOpen")
        
    }
    
    override func viewDidLoad() {
        
        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.allowOverlayTap = true
        
        self.coachMarksController?.dataSource = self
        
        self.timerDisplay?.layer.cornerRadius = 4.0
        self.titleDisplay?.layer.cornerRadius = 4.0
        self.pointsDisplay?.layer.cornerRadius = 4.0
        
        self.coachMarksController?.startOn(self)
        
        
    }
    
    @IBAction func okButton(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
 */