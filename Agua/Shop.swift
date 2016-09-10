//
//  Shop.swift
//  Agua
//
//
//  Created by Edgar Trujillo on 5/4/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//
//
//Organizes main shop page view and gets ready for when user clicks on a reward, then passes info to detail page 
//
//
import Foundation
import Firebase
import UIKit


class Shop: UIViewController {
    @IBOutlet weak var Menu: UIBarButtonItem!
    @IBOutlet weak var points: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    @IBAction func helpButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("gotoinfo", sender: self)
        
    }
    
    
    var categories = [ "Contest","Online GiftCards", "Restuarant GiftCards", "Products"]
    
    var timeStamp: CFAbsoluteTime!
    
    var ads = 0
    
    var totalpoints = 0
    
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
        }else{
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
    
    //not used anymore
    func addObser(){
    }
    
    //not used anymore
    func removeObser(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    
    

    override func viewDidLoad() {
            Menu.target = self.revealViewController()
            Menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            table.delegate = self
            table.dataSource = self
        
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Shop.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Shop.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Shop.myObserverMethod(_:)), name: UIApplicationWillResignActiveNotification , object: nil)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.ads = data
            //        print("\(self.ads) + self.ads")
        })
        
        
        
        currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            self.totalpoints = data
            self.points.title = "\(self.totalpoints)"
            //        print("\(self.ads) + self.ads")
        })
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let ccell = sender as? ccell,
            let DetailPage = segue.destinationViewController as? DetailPage {
            let reward = ccell.reward
            DetailPage.reward = reward
        }
    }}


protocol ShowDetailDelegate {
    func showDetail(displayText:String)
}

extension Shop : ShowDetailDelegate {
    func showDetail(displayText:String){
        performSegueWithIdentifier("ShowDetail", sender: displayText)
    }
}

extension Shop : UITableViewDelegate { }

extension Shop : UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataModel.sharedInstance.categories[section].name
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return DataModel.sharedInstance.categories.count//categories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CategoryRow
        cell.category = DataModel.sharedInstance.categories[indexPath.section]
        return cell}
    
    
    
}















