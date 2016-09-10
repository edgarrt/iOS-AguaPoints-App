//
//  DetailPage.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/10/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


class DetailPage: UIViewController {

var timeStamp: CFAbsoluteTime!
    
var ads = 0
 
var reward:Reward? = nil

var redeemable = 0
    
var key = 0
    
var item = ""
    
var totalpoints = 0
    
var alertTitle = ""
  
var usersEmail = ""
    
var redeemedBy = ""
    
var entries = ""
    
@IBOutlet weak var rewardName: UILabel!
@IBOutlet weak var NavPoints: UIBarButtonItem!
@IBOutlet weak var Description: UILabel!
@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var points: UILabel!
@IBOutlet weak var button: UIButton!
    
    
@IBAction func back(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: {})
}
    
    
    
    
@IBAction func redeemButton(sender: AnyObject) {
    if self.totalpoints >= reward!.price {
        
        //Changes the subtitle to the reward alert...
        if (self.key <= 6){
            alertTitle = "To enter in this contest you'll use \(reward!.price) points of your \(self.totalpoints). Do you wish to continue?"
        }
        else {
            alertTitle = "To redeem this reward you'll use \(reward!.price) points of your \(self.totalpoints). Do you wish to continue?"
        }
        
        SweetAlert().showAlert("Are you sure?", subTitle: "\(alertTitle)", style: AlertStyle.Warning, buttonTitle:"No, nervermind!", buttonColor:UIColor.colorFromRGB(0x000033) , otherButtonTitle:  "Yes, I want it!", otherButtonColor: UIColor.colorFromRGB(0x00CCFF)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("canceled")
                SweetAlert().showAlert("Cancelled!", subTitle: "Saving your points I see...", style: AlertStyle.Error)
                self.dismissViewControllerAnimated(true, completion: {})
                
            }
            else {
                self.totalpoints = self.totalpoints - self.reward!.price
                currentUser.updateChildValues( ["pointsEarned": self.totalpoints])
                self.NavPoints.title = "\(self.totalpoints)"
                
                if (self.key <= 6){
                    let update = "\(self.entries) \(self.usersEmail)"
                    let BASE_URL2 = "agua-app.firebaseIO.com/Shop"
                    let redeemableRef = Firebase(url: "\(BASE_URL2)").childByAppendingPath("\(self.key)")
                    redeemableRef.updateChildValues(["entries": update])
               //     print("\(update)")
                    self.dismissViewControllerAnimated(true, completion: {})
                    SweetAlert().showAlert("Way to go!", subTitle: "You have added one entry to the \(self.reward!.name) contest!", style: AlertStyle.Success)
                 }
                else {
                    let update = "\(self.redeemedBy) \(self.usersEmail),"
                    let BASE_URL2 = "agua-app.firebaseIO.com/Shop"
                    let redeemableRef = Firebase(url: "\(BASE_URL2)").childByAppendingPath("\(self.key)")
                    redeemableRef.updateChildValues(["RedeemedBy": update])
                 //   print("\(update)")
                    self.dismissViewControllerAnimated(true, completion: {})
                    SweetAlert().showAlert("Way to go!", subTitle: "A member from our team will contact you through email soon for your reward!", style: AlertStyle.Success)
                    
            }
            }
            }
    }
    else {
        /*
        let refreshAlert = UIAlertController(title: "Sorry...", message: "Looks like you dont have enough points to redeem this yet. Continue to earn points and come back when you have enough.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
        */
        if self.redeemable == 1{
        let pointsNeeded = reward!.price - self.totalpoints
        SweetAlert().showAlert("Ohhh nooo..", subTitle: "Sorry, but you don't have enough points to claim this yet, earn \(pointsNeeded) more points and come back to redeem this reward.", style: AlertStyle.None)
        
    }
    }
}

    func shareOnFB(){
        
    }
    
    func exitingObserverMethod(notification : NSNotification) {
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        //    print("app is exiting")
    }
    
    
    
    func observerMethodActive ( notification : NSNotification){
        currentUser.updateChildValues( ["online": "yes"])
        
        let elapsedTime = Int (CFAbsoluteTimeGetCurrent() - timeStamp )
        //      print("\(elapsedTime)")
        let mins = elapsedTime / 60
        
        if mins < 7 {
            currentUser.updateChildValues( ["CurrentAdsSeen": self.ads])
        }
        else{
            currentUser.updateChildValues(["CurrentAdsSeen":0])
        }
        
    }
    
    func myObserverMethod(notification : NSNotification) {
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        
        self.timeStamp = CFAbsoluteTimeGetCurrent()
        
        //     print("app went to home screen")
        //     print("app is in background")
        
    }
    
    
    func swipedView(){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func respondToReward(reward : Reward)  {
        
        if item == reward.name {
            
            switch  item {
            case "Amazon $50 Giftcard":
                self.key = 1
            case "GoPro HERO":
                self.key = 2
            case "Nixon Watch":
                self.key = 3
            case "PlayStation 4":
                self.key = 4
            case "Sephora $50 Giftcard":
                self.key = 5
            case "Ulta $50 Giftcard":
                self.key = 6
            case "Amazon $10 Giftcard":
                self.key = 7
            case "Best Buy $20 Giftcard":
                self.key = 8
            case "Nike $25 Giftcard":
                self.key = 9
            case "Playstation $10 Giftcard":
                self.key = 10
            case "Sephora $25 Giftcard":
                self.key = 11
            case "Victoria Secrets $25 Giftcard":
                self.key = 12
            case "Walmart $10 Giftcard":
                self.key = 13
            case "Xbox live $10 Giftcard":
                self.key = 14
            case "Applebees $20 Giftcard":
                self.key = 15
            case "iHop $10 Giftcard":
                self.key = 16
            case "Buffalo Wild Wings $20 Giftcard":
                self.key = 17
            case "Red Lobster $15 Giftcard":
                self.key = 18
            case "In-N-Out $15 Giftcard":
                self.key = 19
            case "Olive Garden $20 Giftcard":
                self.key = 20
            case "PizzaHut $15 Giftcard":
                self.key = 21
            case "Starbucks $10 Giftcard":
                self.key = 22
            case "Kohl's $15 Giftcard":
                self.key = 23
            case "Regal $10 Giftcard":
                self.key = 24
            case "Target $10 Giftcard":
                self.key = 25
            case "Gamestop $15 Giftcard":
                self.key = 26
            case "Footlocker $10 Giftcard":
                self.key = 27
            case "Lowes $20 Giftcard":
                self.key = 28
            case "Dave & Busters $15 Giftcard":
                self.key = 29
            case "Cold Stone $10 Giftcard":
                self.key = 30
            case "Panera $25 Giftcard":
                self.key = 31
            case "Red Robin $20 Giftcard":
                self.key = 32
            default:
                break
            }
        }
    }
    
    
    func addObser(){
        
    }
    
    func removeObser(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    
    override func viewDidLoad() {
        let swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(DetailPage.swipedView))
        self.view.addGestureRecognizer(swipeRec)
       
        if let reward = reward {
            rewardName.text = reward.name
            Description.text = reward.description
            imageView.image = UIImage(named: reward.image)
            item = reward.name
            respondToReward(reward)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailPage.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailPage.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailPage.myObserverMethod(_:)), name: UIApplicationWillResignActiveNotification , object: nil)
        
}
    override func viewDidAppear(animated: Bool) {
        currentUser.updateChildValues( ["online": "yes"])
        currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.totalpoints = data
            self.NavPoints.title = "\(self.totalpoints)"
        })
        
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
            //        print("\(self.ads) + self.ads")
        })
        
        
        currentUser.childByAppendingPath("email").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! String
            self.usersEmail = data
     //       print("\(self.usersEmail)")
            })
        
        let BASE_URL2 = "agua-app.firebaseIO.com/Shop"
        let redeemableRef = Firebase(url: "\(BASE_URL2)").childByAppendingPath("\(self.key)")
        redeemableRef.childByAppendingPath("redeemable").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.redeemable = data
     //       print("\(data)")
        if self.redeemable == 1 {
            self.button.hidden = false
            self.button.enabled = true
        }
        else{
            self.button.hidden = true
            self.button.enabled = false
        }
        })
        
        if (self.key <= 6){
            points.text = "Points needed to enter: \(reward!.price)"
        
            let BASE_URL2 = "agua-app.firebaseIO.com/Shop"
            let redeemableRef = Firebase(url: "\(BASE_URL2)").childByAppendingPath("\(self.key)")
            redeemableRef.childByAppendingPath("entries").observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                let data = snapshot.value as! String
                self.entries = data
                 })
        }
        else {
            points.text = "Points needed to redeem: \(reward!.price)"
            
            let BASE_URL2 = "agua-app.firebaseIO.com/Shop"
            let redeemableRef = Firebase(url: "\(BASE_URL2)").childByAppendingPath("\(self.key)")
            redeemableRef.childByAppendingPath("RedeemedBy").observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                let data = snapshot.value as! String
                self.redeemedBy = data
                })
        }

    }

    override func viewWillDisappear(animated: Bool) {
        }
}


