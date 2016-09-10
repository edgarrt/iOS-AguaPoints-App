//
//  MorePoints.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/13/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MorePoints: UIViewController, AdColonyAdDelegate
{
    @IBOutlet weak var Menu: UIBarButtonItem!
    @IBOutlet weak var points: UIBarButtonItem!
    @IBOutlet weak var button:        UIButton!
    @IBOutlet weak var text:          UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var statusLabel:   UILabel!
    @IBOutlet weak var spinner:       UIActivityIndicatorView!
    
    var maxed = true
    
    var newDay = false
    
    var extraPoints = 0
    
    var Timestamp:NSTimeInterval = NSDate().timeIntervalSince1970 / 3600
    
    var TodaysDate:NSTimeInterval = NSDate().timeIntervalSince1970 / 3600
    
    var timeRemaining:Double = 0.0
    
    var timeNeeded = 0.0
    
    var totalPoints = 0
    
    var timeStamp: CFAbsoluteTime!
    
    var ads = 0
    
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
            currentUser.updateChildValues( ["CurrentAdsSeen": 0])
        }
        
    }
    
    func myObserverMethod(notification : NSNotification) {
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        
        self.timeStamp = CFAbsoluteTimeGetCurrent()
        
        //     print("app went to home screen")
        //     print("app is in background")
        
    }
    

    
    
    //=============================================
    // MARK:- UIViewController Overrides
    //=============================================
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Menu.target = self.revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MorePoints.myObserverMethod(_:)), name: UIApplicationDidEnterBackgroundNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MorePoints.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MorePoints.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
    //    self.updateCurrencyBalance()
    //    self.addObservers()
        self.spinner.hidden = true
        self.statusLabel.hidden = true
        
        if self.extraPoints < 5 {
            self.button.hidden = false
        }
        else{
            self.button.hidden = true
            self.statusLabel.hidden = false
            self.statusLabel.text = "Sorry, but you've maxed out your daily bonus points, come back tomorrow to get more!"
        }
        
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
            //        print("\(self.ads) + self.ads")
        })
        
        
        currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.totalPoints = data
            self.points.title = "\(self.totalPoints)"
            
            
        })
        
        currentUser.childByAppendingPath("extraPoints").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            if data > 4 {
                self.maxed = true
                self.extraPoints = data
            }
            else{
                self.maxed = false
                self.extraPoints = data
                self.button.hidden = false
            }
        })
        
        if self.maxed == true {
            currentUser.childByAppendingPath("timeStamp").observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                let data = snapshot.value as! Double
                self.timeRemaining = round(self.TodaysDate - data)
                if self.timeRemaining >= 24{
                    self.extraPoints = 0
                    self.newDay = true
                    self.maxed = false
                }
                else{
                    self.timeNeeded = 24 - round(self.timeRemaining)
                    self.newDay = false
                    self.zoneOff()
                    
                }
            })
            
            if self.maxed == false {
                currentUser.updateChildValues(["timeStamp" : 0])
                self.button.hidden = false
                
            }
            if self.newDay == true {
                currentUser.updateChildValues(["timeStamp" : 0])
                currentUser.updateChildValues(["extraPoints" : 0])
                self.button.hidden = false
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewWillDisappear(animated: Bool) {
       }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.All
    }
    
    override func shouldAutorotate() -> Bool
    {
        return true
    }
    
    //=============================================
    // MARK:- UI Updates
    //=============================================
    
    func addObservers()
    {
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MorePoints.updateCurrencyBalance), name:"currencyBalanceChange", object: nil)
       }
    
    func removeObservers()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "zoneLoading", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "zoneOff", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "zoneReady", object: nil)
    //  NSNotificationCenter.defaultCenter().removeObserver(self, name: "currencyBalanceChange", object: nil)
    }
    
    func zoneReady()
    {
        self.spinner.stopAnimating()
        self.spinner.hidden = true
        self.statusLabel.alpha = 0;
        UIView.animateWithDuration(1.0, animations: {
            self.button.alpha  = 1
        })
    }
    
    func zoneOff()
    {
        self.spinner.stopAnimating()
        self.spinner.hidden = true
        self.button.alpha = 0;
        self.statusLabel.hidden = false
        self.statusLabel.text = "Sorry, but you've maxed out your daily bonus points, come back tomorrow to get more!"
    }
    
    func zoneLoading()
    {
        self.spinner.hidden = false
        self.spinner.startAnimating()
        self.button.alpha = 0
        UIView.animateWithDuration(0.5, animations: {
            self.statusLabel.alpha = 1.0;
        })
    }
    
    func updateCurrencyBalance()
    {
        //Get currency balance from persistent storage and display it
        if let wrappedBalance = NSUserDefaults.standardUserDefaults().objectForKey(currencyBalance) as! NSNumber? {
            self.currencyLabel.text = wrappedBalance.stringValue
        } else {
            self.currencyLabel.text = "0"
            
        }
    }
    
    //=============================================
    // MARK:- AdColony
    //=============================================
    
    @IBAction func triggerVideo(sender: AnyObject)
    {
        if self.extraPoints < 4 {
        
            extraPoints += 1
            
            self.totalPoints += 1
            
            AdColony.playVideoAdForZone(adcolonyZoneID, withDelegate: self, withV4VCPrePopup: false, andV4VCPostPopup: false)
            
            currentUser.updateChildValues(["extraPoints" : extraPoints])
            currentUser.updateChildValues(["timeStamp" : 0])
            currentUser.updateChildValues(["pointsEarned" : self.totalPoints])
            self.points.title = "\(self.totalPoints)"
            
            
            
        }
        else if self.extraPoints == 4 {
            
            AdColony.playVideoAdForZone(adcolonyZoneID, withDelegate: self, withV4VCPrePopup: false, andV4VCPostPopup: false)
            
            extraPoints += 1
            
            self.totalPoints += 1
            currentUser.updateChildValues(["extraPoints" : extraPoints])
            currentUser.updateChildValues(["timeStamp" : round(self.Timestamp)])
            currentUser.updateChildValues(["pointsEarned" : self.totalPoints])
            self.points.title = "\(self.totalPoints)"
            self.statusLabel.text = "Sorry, but you've maxed out your daily bonus points, come back tomorrow to get more!"
            self.zoneOff()
        }
        else if self.extraPoints > 4 {
            SweetAlert().showAlert("Ohhh nooo..", subTitle: "Sorry, but you watched all your extra cycles for the day already. Come back in 24 hours to have a chance to earn another 3 daily points.", style: AlertStyle.None)
        }
    }
 
}