//
//  Share.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/6/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



class Share: UIViewController {
    var timeStamp: CFAbsoluteTime!
    
    var ads = 0
    
    var totalpoints = 0
    
    var points = 0
    
    var alreadyShared = 0
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var shareDisplay: UILabel!
    
    @IBOutlet weak var new: UIBarButtonItem!
    
    
    @IBAction func facebookLogin (sender: AnyObject){
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil { print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled { print("Facebook login was cancelled.")
            } else { print("You’re in")}
        });
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
    
    func buttonTapped() {
        if alreadyShared == 0 {
        
            print("Button tapped!")
            self.totalpoints = points + 50
            self.new.title = "\(self.totalpoints)"
            currentUser.updateChildValues( ["pointsEarned": self.totalpoints])
            currentUser.updateChildValues( ["FacebookShare": 1])
            self.alreadyShared = 1
            self.shareDisplay.text = "Looks like you already shared this to get your 50 bonus points."
            
    }
}
    
    
    func addObser(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Share.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Share.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Share.myObserverMethod(_:)), name: UIApplicationWillResignActiveNotification , object: nil)
        
    }
    
    func removeObser(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override func viewDidLoad() {
        Menu.target = self.revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "https://www.aguapoints.org")
        content.contentTitle = "Get Rewarded For Not Using Your Phone."
        content.contentDescription = "Agua Points gives users rewards for not using their phone to support a cause to build water wells. All one has to do is simply open up the application, lock your phone, and you'll start being rewarded with points. Later one can redeem the points for rewards. Agua Points is a great way to be productive while still making an impact in the world and to be rewarded while doing so at the same time."
        content.imageURL = NSURL(string: "https://static.wixstatic.com/media/b67d5d_c2ad89dea5df4b1ea404efe034690801.jpg/v1/fill/w_260,h_260,al_c,q_80,usm_0.66_1.00_0.01/b67d5d_c2ad89dea5df4b1ea404efe034690801.jpg")
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 450, 100, 25)
        button.addTarget(self, action: #selector(Share.buttonTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        
        addObser()
        
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
            //        print("\(self.ads) + self.ads")
        })
        
        
        currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.points = data
            self.new.title = "\(self.points)"
        })
        
        currentUser.childByAppendingPath("FacebookShare").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.alreadyShared = data
            if self.alreadyShared == 1 {
                self.shareDisplay.text = "Looks like you already shared this to get your 50 bonus points."
            }
            
        })

    
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
       }
    
    
    
}

