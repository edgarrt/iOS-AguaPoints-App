//
//  Settings.swift
//  Agua
//
//  Created by Edgar Trujillo on 3/27/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//
import Foundation
import Firebase
import UIKit

class Settings : UIViewController {
    
    var timeStamp: CFAbsoluteTime!
    
    var ads = 0
    
    var totalpoints = 0
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var points: UIBarButtonItem!
    
    
    @IBAction func problemButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aguapoints.org/#!blank/lfclr")!)
    }
    @IBAction func termsButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.aguapoints.org/#!terms-of-use/kq8qa")!)
    }
    
    
    @IBAction func policyButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.iubenda.com/privacy-policy/7836898")!)
    }
    
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBAction func logoutAction(sender: AnyObject)
    {
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        
        DataService.dataService.CURRENT_USER_REF.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        self.performSegueWithIdentifier("gotologin", sender: self)
    }
    
    
    
    
    func exitingObserverMethod(notification : NSNotification) {
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
//        print("app is exiting")
    }
    
    
    
    
    
    func observerMethodActive ( notification : NSNotification){
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        currentUser.updateChildValues( ["online": "yes"])
        
        let elapsedTime = Int (CFAbsoluteTimeGetCurrent() - timeStamp )
   //     print("\(elapsedTime)")
        let mins = elapsedTime / 60
        
        if mins < 7 {
            currentUser.updateChildValues( ["CurrentAdsSeen": self.ads])
        }
        else{
        currentUser.updateChildValues( ["CurrentAdsSeen": 0])
        }
    }
    
    
    
    func myObserverMethod(notification : NSNotification) {
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        
        currentUser.updateChildValues( ["online": "no"])
        currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
        
        
        self.timeStamp = CFAbsoluteTimeGetCurrent()
        
        
  //      print("app went to home screen")
  //      print("app is in background")
        
    }
    
    
    func addObser(){
        
    }
    
    func removeObser(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        Menu.target = self.revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        let BASE_URL = "agua-app.firebaseIO.com"
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)
        
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
       //     print("\(self.ads) + self.ads")
        })
        
        currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.totalpoints = data
            self.points.title = "\(self.totalpoints)"
            //        print("\(self.ads) + self.ads")
        })
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Settings.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Settings.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Settings.myObserverMethod(_:)), name: UIApplicationWillResignActiveNotification , object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        }
    
}