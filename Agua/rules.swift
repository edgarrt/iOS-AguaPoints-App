//
//  rules.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/3/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class rules: UIViewController {
    var timeStamp: CFAbsoluteTime!
    
    var ads = 0
    
    @IBAction func gotToConstruction(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(true , completion: nil )
    }
    
    
    
    func exitingObserverMethod(notification : NSNotification) {
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        //       print("app is exiting")
    }
    
    
    
    
    
    func observerMethodActive ( notification : NSNotification){
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        currentUser.updateChildValues( ["online": "yes"])
        
        let elapsedTime = Int (CFAbsoluteTimeGetCurrent() - timeStamp )
        //     print("\(elapsedTime)")
        let mins = elapsedTime / 60
        
        if mins < 30 {
            currentUser.updateChildValues( ["CurrentAdsSeen": self.ads])
        }
        
    }
    
    
    
    func myObserverMethod(notification : NSNotification) {
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        
        
        self.timeStamp = CFAbsoluteTimeGetCurrent()
        
        
        //     print("app went to home screen")
        //     print("app is in background")
        
    }

    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.myObserverMethod(_:)), name: UIApplicationDidEnterBackgroundNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
        
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
            //    print("\(self.ads) + self.ads")
        })
        
        
        
    }
    

    
    
}
