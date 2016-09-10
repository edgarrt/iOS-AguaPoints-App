//
//  Construction.swift
//  Agua
//
//  Created by Edgar Trujillo on 4/17/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Construction: UIViewController {
    
    var timeStamp: CFAbsoluteTime!
    
    var ads = 0
    
    
    
    @IBAction func gotToShop(sender: AnyObject)
    {
        
        self.dismissViewControllerAnimated(true , completion: nil )
    }
    

    @IBAction func rulesButton(sender: AnyObject) {
        self.performSegueWithIdentifier("gotorules", sender: self)
    }
    
    
    
    
    func exitingObserverMethod(notification : NSNotification) {
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
 //       print("app is exiting")
    }
    
    
    
    
    
    func observerMethodActive ( notification : NSNotification){
        currentUser.updateChildValues( ["online": "yes"])
        
        let elapsedTime = Int (CFAbsoluteTimeGetCurrent() - timeStamp )
   //     print("\(elapsedTime)")
        let mins = elapsedTime / 60
        
        if mins < 30 {
            currentUser.updateChildValues( ["CurrentAdsSeen": self.ads])
        }
        
    }
    
    
    
    func myObserverMethod(notification : NSNotification) {
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        
        
        self.timeStamp = CFAbsoluteTimeGetCurrent()
        
        
   //     print("app went to home screen")
   //     print("app is in background")
        
    }
    
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.myObserverMethod(_:)), name: UIApplicationDidEnterBackgroundNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
        
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
        //    print("\(self.ads) + self.ads")
        })
        

        
    }
    
    
    
}
