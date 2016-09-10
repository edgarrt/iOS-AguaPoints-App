//
//  ViewController.swift
//  Agua
//
//  Created by Edgar Trujillo on 3/27/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//
//
//
//
//
//
//                  *****   Main View Controller For Agua Points App *****
//
//
//
//




import Foundation
import UIKit
import Firebase
import GoogleMobileAds
import FBSDKCoreKit
import FBSDKLoginKit
import Instructions

class HomeScreen: UIViewController, UITextFieldDelegate, GADInterstitialDelegate, CoachMarksControllerDelegate, CoachMarksControllerDataSource{
    
    @IBAction func adButton(sender: AnyObject) {

        // Plays Ads as long as within app hours of 7am - 9pm
        let hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: NSDate())
        //      print("\(hour)")
        if hour > 6 && hour < 21 {
            
            AdColony.playVideoAdForZone(adcolonyZoneID2, withDelegate: nil)
            adsWatched += 1
        
    }
        else {
            afterTime()
        }
    }
    
    @IBOutlet weak var adLabel: UIBarButtonItem!
    
    @IBOutlet weak var pts: UIBarButtonItem!
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    @IBOutlet weak var titleDisplay: UILabel!
    
    @IBOutlet weak var pointsDisplay: UILabel!
    
    @IBOutlet weak var menuDisplay: UILabel!
    
    @IBOutlet weak var ADButton: UIButton!
    
    @IBOutlet var waterImage: UIImageView!
    
    @IBOutlet var coach: UIImageView!
    @IBOutlet var avatarVerticalPositionConstraint: NSLayoutConstraint?

    

    var firebaseref: Firebase!

    var timerCycle = 2400
    
    var refCycle = 0
    
    var originaltimerCycle = 0
    
    var time = 0
    
    var timerRunning = false
    
    var aniRunning = false

    var timer = NSTimer()
    
    var aniTimer = NSTimer()
    
    var minutes = 0
    
    var seconds = 0
    
    var totalpoints = 0
    
    var Ad: GADInterstitial!
    
    var adsWatched = 0
    
    var inAppAds = 0
    
    var inApp = true 
    
    var myAni = [UIImage]()
    
    var timeStamp: CFAbsoluteTime!
    
    var backgroundTimeStamp: CFAbsoluteTime!
    
    var watched = 0
    
    var cyclesCompleted = 0
    
    var varView = Int()
    
    var withinHours = false
    
    var stayed = false
    
    var coachMarksController: CoachMarksController?
    
    let coachText = "Hey you! Thank you for supporting Agua Points! You are not only supporting us, but supporting the mission to provide drinking water to those that are desperately in need. Because no good deed ever goes unnoticed, the more points you earn, the more money goes towards building wells, and the closer you are to redeeming a gift card to some of your favorite stores. Enjoy!"
    
    let titleText = "This is the main page where you'll get your points. Start by locking your screen here."
    let timerText = "This shows you how much time is left until you earn your next point."
    let pointsText = "You can see how many points you've earned by looking here or on the navigation bar next to the water drop."
    let adText = "You don't have to wait 45 minutes to get your points, click here to reduce the amount of time needed to get your points by 5 minutes."
    let menuText = "You can spend and earn more points by clicking here or swiping your screen to the left to access the rest of the app's features."
    
    let nextButtonText = "Ok!"


    
    func removeCoachFace(){
        coach.image = nil
    }
    //MARK: - Protocol Conformance | CoachMarksControllerDataSource
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 6
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.coachMarkForView(self.coach) { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(ovalInRect: CGRectInset(frame, -4, -4))
            }
        case 1:
            return coachMarksController.coachMarkForView(self.titleDisplay)
        case 2:
            return coachMarksController.coachMarkForView(self.timerDisplay)
        case 3:
            return coachMarksController.coachMarkForView(self.pointsDisplay)
        case 4:
            return coachMarksController.coachMarkForView(self.ADButton)
        case 5:
            return coachMarksController.coachMarkForView(self.menuDisplay)
        default:
            return coachMarksController.coachMarkForView()
        }
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = self.coachText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = self.titleText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = self.timerText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = self.pointsText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 4:
            coachViews.bodyView.hintLabel.text = self.adText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
        case 5:
            coachViews.bodyView.hintLabel.text = self.menuText
            coachViews.bodyView.nextLabel.text = self.nextButtonText
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstAppOpen")
            self.viewDidAppear(true)
            
        default: break
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    //MARK: - Protocol Conformance | CoachMarksControllerDelegate
    func coachMarksController(coachMarksController: CoachMarksController, inout coachMarkWillShow coachMark: CoachMark, forIndex index: Int) {
        if index == 0 {
            // We'll need to play an animation before showing up the coach mark.
            // To be able to play the animation and then show the coach mark and not stall
            // the UI (i. e. keep the asynchronicity), we'll pause the controller.
            coachMarksController.pause()
            
            // Then we run the animation.
            self.view.needsUpdateConstraints()
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) -> Void in
                    
                    // Once the animation is completed, we update the coach mark,
                    // and start the display again.
                    coachMarksController.updateCurrentCoachMarkForView(self.coach, pointOfInterest: nil) {
                        (frame: CGRect) -> UIBezierPath in
                        return UIBezierPath(ovalInRect: CGRectInset(frame, -4, -4))
                    }
                    
                    coachMarksController.resume()
            })
        }
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear coachMark: CoachMark, forIndex index: Int) {
        if index == 1 {
            self.avatarVerticalPositionConstraint?.constant = 0
            self.view.needsUpdateConstraints()
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func didFinishShowingFromCoachMarksController(coachMarksController: CoachMarksController) {
        UIView.animateWithDuration(1, animations: { () -> Void in
            })
    }
    
    func notify()
    {
    //local notification that appears after 5 secs once screen locked.
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.alertBody = "Hey you! You're currently earning Agua Points!"
        notification.alertAction = "to see how many points you've earned!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
     //       print("notifications not allowed")
            return
        }
      }
    
    func adswatched() {
        //Gets current # of Ads watched, creates & sets timer to specific Ad #
        //
        //
        switch (self.adsWatched)
        {
        case 1:
            timer.invalidate()
         self.timerCycle = 2100
         self.originaltimerCycle = 2100
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
        
        case 2:
            timer.invalidate()
            self.timerCycle = 1800
            self.originaltimerCycle = 1800
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
        case 3:
            
            timer.invalidate()
            self.timerCycle = 1500
            self.originaltimerCycle = 1500
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
        case 4:
            timer.invalidate()
            self.timerCycle = 1200
            self.originaltimerCycle = 1200
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
        case 5:
            timer.invalidate()
            self.timerCycle = 900
            self.originaltimerCycle = 900
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
            
        case 6...99:
            SweetAlert().showAlert("Hold on there...", subTitle: "You've used all your accelrated timers for this session already.", style: AlertStyle.None)
            
            timer.invalidate()
            self.timerCycle = 900
            self.originaltimerCycle = 900
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
            
        default:
            self.timerCycle = 2400
            self.originaltimerCycle = 2400
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
            timerRunning = true
        }
}
    
    
    func setUp(){
        //gets current points earned
        //
        currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let data = snapshot.value as! Int
            if data > 0 {
                self.totalpoints = data
                self.pointsDisplay.text = "\(self.totalpoints)"
                self.pts.title = "\(self.totalpoints)"
            }
            else {
                self.totalpoints = 0
                self.pointsDisplay.text = "0"
                self.pts.title = "0"
            }
        })
        
    }
 

    func counting(){
        timerCycle += -1// timer setup
        
    
       // makes time-remaining nice
        minutes = Int( timerCycle / 60) // gets minutes
        seconds = Int ( timerCycle % 60 )  // gets seconds
        
       //displays time until next point
        timerDisplay.text = "\(minutes) minutes \(seconds) secs"
            
        //completed cycle
        //
        if timerCycle == 0 {
            
           var pointsEarned = self.totalpoints
            pointsEarned += 1
            
            currentUser.updateChildValues( ["pointsEarned": pointsEarned])
            self.pointsDisplay.text = "\(pointsEarned)"
            self.pts.title = "\(pointsEarned)"
        
        //resets timer with consideration of # of ADs watched 
        //
            switch (adsWatched){
                
            case 1:
                timerCycle = 2100
        
            case 2:
                timerCycle = 1800
            
            case 3:
                timerCycle = 1500
            
            case 4:
                timerCycle = 1200
            
            case 5...99:
                timerCycle = 900
            
            default:
                timerCycle = 2400
            }
        }
        

}
    
    
  //Displays Alert saying points cant be earned since not within app hours
    func afterTime(){
        SweetAlert().showAlert("Ohhh Noo.. ", subTitle: "We're sorry its past 9PM, therefore you wont be able to earn points at the moment. Come back tomorrow morning to start earning points again.", style: AlertStyle.None)
    }
    
    
  //Pauses timer when app in background
    func pauseTimer() {
        timer.invalidate()
    }

   // Creates timer when app back is active
    func createTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(HomeScreen.counting), userInfo: nil, repeats: true)
        timerRunning = true
    }
    
    
    //Called when app is becoming active again 
    //calcs time off phone, adds pts if cycles completed
    func observerMethodActive ( notification : NSNotification){
  
        //checks if still within hours
        let hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: NSDate())
        
        if hour > 6 && hour < 21 {
            withinHours = true
        }
        else{
            withinHours = false
        }
        
        
        if withinHours == true {
            
        //resets screen locked bool to false
        NSUserDefaults.standardUserDefaults().setValue( false , forKey:"kDisplayStatusLocked")
        
        //timeStamp checks if app is reloaded from icon or screen on
        
            if timeStamp == 0 {
           
                // app reloaded from home/call/text
                currentUser.updateChildValues( ["online": "yes"])
            
                let timeDiff = Int( CFAbsoluteTimeGetCurrent() - backgroundTimeStamp)
            
                let minutes = timeDiff / 60
            
           
                // if off app for more than 10 minutes, app starts over
            
                if minutes > 10 {
                
                    self.timerCycle = 2700
                
                    self.adsWatched = 0
                
                    createTimer()
           
        
                    /*
            
                     //could do without this ani code ????
                
                     waterImage.image = UIImage(named: "solodrops")
                
                     let xPos =  waterImage.frame.origin.x
                
                     let yPos =  waterImage.frame.origin.y
                
                     let options = UIViewAnimationOptions.Repeat
                
                     UIView.animateWithDuration(1.5, delay:0.0, options: options ,animations: {
                    self.waterImage.frame = CGRect(x:  xPos, y: yPos + 80 , width: 286, height: 341)
                    }, completion: nil)
        
                     */
            
                }
            
                else {
            
                    // Was off App for less than 10 minutes
                
                    createTimer()
            
                }
            
                waterImage.image = UIImage(named: "solodrops")
            
                let xPos =  waterImage.frame.origin.x
            
                let yPos =  waterImage.frame.origin.y
            
                let options = UIViewAnimationOptions.Repeat
            
                UIView.animateWithDuration(1.5, delay:0.0, options: options ,animations: {
                self.waterImage.frame = CGRect(x:  xPos, y: yPos + 80 , width: 286, height: 341)
                }, completion: nil)

            }
        
            else {
            
                //app reloaded from lock screen
            
                //earning points
            
                //calcs time of phone & time needed for next cycle
            
                if stayed == true {
            
           
                    currentUser.updateChildValues( ["online": "yes"])
            
                    let elapsedTime = Int (CFAbsoluteTimeGetCurrent() - timeStamp )
            
                    let mins = elapsedTime / 60
            
                    let seconds = elapsedTime - ( mins * 60)
            
                    let firstCycle = Int ( elapsedTime / refCycle)
         
          
                    //Debug...
        
                    //   print("\(elapsedTime)")
         
          
                    //   print("\(timerCycle)")
         
            
                    //   print("\(cyclesCompleted)")
        
          
                    if firstCycle >= 1 {
                    
            
                        //meaning cycles were completed
             
                        //also at least one was completed
                
                
                        let extraTime = elapsedTime - refCycle
                
              
                        let extraCycles = Int ( extraTime / self.originaltimerCycle)
                
                        
                    
                        if extraCycles >= 1 {
                    
                     
                            // means more cycles were completed
                   
                            
                       
                            totalpoints += 1
                    
                   
                            totalpoints += extraCycles
                    
                   
                            let remainingTime = extraTime % self.originaltimerCycle
                    
                   
                            self.timerCycle = self.originaltimerCycle
                    
                   
                            self.timerCycle = self.timerCycle - remainingTime
                    
                   
                            pointsDisplay.text = "\(totalpoints)"
                    
                   
                            pts.title = "\(totalpoints)"
                    
                   
                            currentUser.updateChildValues( ["pointsEarned": totalpoints])
                    
                    
                            createTimer()
                    
                   
                            SweetAlert().showAlert("Congratulations!", subTitle: "You were off your phone for \(mins) and \(seconds) seconds and earned \(extraCycles + 1) points.", style: AlertStyle.None)
                
                        }
               
                    
                        else {
                
                            
                        
                        
                            //means only one cycle was completed
                    
                   
                            timerCycle = self.originaltimerCycle
                    
                       
                            timerCycle = timerCycle - extraTime
                    
                       
                            totalpoints += 1
                    
                       
                            pointsDisplay.text = "\(totalpoints)"
                    
                      
                            pts.title = "\(totalpoints)"
                    
                    
                      
                            currentUser.updateChildValues( ["pointsEarned": totalpoints])
                   
                       
                            createTimer()
                   
                       
                            SweetAlert().showAlert("Congratulations!", subTitle: "You were off your phone for \(mins) and \(seconds) seconds and earned 1 point.", style: AlertStyle.None)
                       
                        }
                    
                    }
                    
                    
            
                    else{
                
                        //meaning no cycles were completed
                
                        SweetAlert().showAlert("Congratulations!", subTitle: "You were off your phone for \(mins) minutes and \(seconds) seconds.", style: AlertStyle.None)
              
                        timerCycle = timerCycle - elapsedTime
               
                        createTimer()
          
                    }
        
            
    
                }
         
            
            
                if stayed == false{
                
                    SweetAlert().showAlert("Ohh nooo.", subTitle: "We detected that you used your phone while earning points. Next time open from the alert or just slide to unlock to claim your points before using your phone.", style: AlertStyle.None)
              
                    createTimer()
            
                }
            
            }
            

        }
       
            //if app not within hours displays alert
        
        else if withinHours == false{
        
            afterTime()
        
        }

    }

    //not used anymore.....
    func myObserverMethod(notification : NSNotification) {
        
    }
    
    func exitingObserverMethod(notification : NSNotification) {
        // called when app is suspeneded/terminated within the app 
        //ends session by reseting everything 
        
            currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
            currentUser.updateChildValues( ["online": "no"])
    }
    
    
    
    //called when app is going in background
    func pauseObserverMethod(notification : NSNotification){
        
        if NSUserDefaults.standardUserDefaults().valueForKey("kDisplayStatusLocked") as! Bool == true {
       
            //earning points
            //print("screen locked")
            pauseTimer()
            self.timeStamp = CFAbsoluteTimeGetCurrent()
            self.refCycle = timerCycle
      
            //     print("\(self.refCycle)")
            self.stayed = true
            notify()
        }
        else{
        
            // app went to background by home button, call, or text
            //not earning points, pauses timer cycle
            
            currentUser.updateChildValues( ["CurrentAdsSeen": 0 ])
            currentUser.updateChildValues( ["online": "no"])
       //     print("app went to home screen")
       //     print("app is in background")
            self.timeStamp = 0
            self.backgroundTimeStamp = CFAbsoluteTimeGetCurrent()
            pauseTimer()
        }
    }
    
    func local(){
        //triggered when app is opened from local notification
    self.stayed = true
    }
    
    
    //not used anymore...
    func removeObser(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "Local", object: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //adds menu to target button on nav.
        Menu.target = self.revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //reveals menu with swipe
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //timer not runnning by default
        timerRunning = false
        
        self.coachMarksController = CoachMarksController()
        self.coachMarksController?.allowOverlayTap = true
        
        self.coachMarksController?.dataSource = self
        
        self.timerDisplay?.layer.cornerRadius = 4.0
        self.titleDisplay?.layer.cornerRadius = 4.0
        self.pointsDisplay?.layer.cornerRadius = 4.0
        

        
        
        //Observers for app states
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.observerMethodActive(_:)), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.exitingObserverMethod(_:)), name: UIApplicationWillTerminateNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.pauseObserverMethod(_:)), name: UIApplicationWillResignActiveNotification , object: nil)
        
        //Observer for screen lock
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), nil, LockNotifierCallback.notifierProc(), "com.apple.springboard.lockcomplete", nil, CFNotificationSuspensionBehavior.DeliverImmediately)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeScreen.local) , name: "Local", object: nil)
    }
    
        
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
   
        NSUserDefaults.standardUserDefaults().setValue( false , forKey:"kDisplayStatusLocked")
        
  
        // if first open, sends user to Thank-you page else continues like normal
        
        if NSUserDefaults.standardUserDefaults().boolForKey("firstAppOpen") == false {
            // First App Open
        
            coach.hidden = false
            
            self.coachMarksController?.startOn(self)
            
       
            //   self.performSegueWithIdentifier("firstOpen", sender: self)
        
        }
        
        else{

            
            
            removeCoachFace()
    
 
            //checks if within app hours
        
            let hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: NSDate())
  
            //      print("\(hour)")
        
            if hour > 6 && hour < 21 {
            
                self.withinHours = true
            
                self.stayed = false
           
                
            
                titleDisplay.text = "Lock your Phone to begin."
            
                currentUser.updateChildValues([
                "online" : "yes" ])
            
                
            
                timerRunning = true
            
                if timerRunning == true {
                
                
                    setUp()
                
               
                    aniRunning = true
                
                    let modelName = UIDevice.currentDevice().modelName
                
                    if modelName > 12 {
                    
                        aniRunning = false
                    
                        waterImage.image = UIImage(named: "solodrops")
                    
                        let imageName = "solodrops"
                    
                        let image = UIImage(named: imageName)
                    
                        let imageView = UIImageView(image: image!)
                    
                        imageView.frame = CGRect(x: 80, y: 60, width: 286, height: 341)
                    
                        view.addSubview(imageView)
                    
                        waterImage.image = nil
                    
                
                    }
                
                
                    currentUser.childByAppendingPath("CurrentAdsSeen").observeSingleEventOfType(.Value, withBlock: {
                    
                        snapshot in
                    
                        let data = snapshot.value as! Int
                    
                    
                        if data != 0 {
                        
                            self.adsWatched = data
          
                            //  print("\(self.adsWatched)")
                        
                            self.counting()
                        
                            self.adswatched()
                    
                        }
                    
                        else{
                        
                            self.adsWatched = 0
                        
                            self.counting()
                        
                            self.adswatched()
                    
                        }
                
                    })
                
            
                    //creates animation. Should still fix for ipad, if plan to add later..
                
                    if aniRunning == true {
                
                        waterImage.image = UIImage(named: "solodrops")
                
                        let xPos =  waterImage.frame.origin.x
                
                        let yPos =  waterImage.frame.origin.y
                
              
                        let options = UIViewAnimationOptions.Repeat
               
                        UIView.animateWithDuration(1.5, delay:0.0, options: options ,animations: {
                    
                   
                            self.waterImage.frame = CGRect(x:  xPos, y: yPos + 80 , width: 286, height: 341)
                    
                            }, completion: nil)
               
                    }
           
                }
      
            }
         
        
            else{
            
                //App is not within hours, displays alert, displays users pts.
            
                //
            
                currentUser.updateChildValues( ["online": "no"])
            
                afterTime()
            
                self.titleDisplay.text = "Sorry, Come Back Soon..."
            
                waterImage.image = nil
            
           
                self.withinHours = false
            
           
                currentUser.childByAppendingPath("pointsEarned").observeSingleEventOfType(.Value, withBlock: {
                
                    snapshot in
                
                    let data = snapshot.value as! Int
                
                    if data > 0 {
                    
                        self.totalpoints = data
                    
                        self.pointsDisplay.text = "\(self.totalpoints)"
                    
                        self.pts.title = "\(self.totalpoints)"
                
                    }
                
                    else {
                    
                        self.totalpoints = 0
                    
                        self.pointsDisplay.text = "0"
                    
                        self.pts.title = "0"
                
                    }
                
                })
        
            }

        }

    }

    override func viewWillAppear(animated: Bool) {
        }
    
    
    override func viewWillDisappear(animated: Bool) {
   // sets ads in firebase for when user goes to diff view
   //     print("View will disapper")
        inAppAds = adsWatched
   //     print("\(inAppAds)")
        currentUser.updateChildValues( ["CurrentAdsSeen": inAppAds ])
        timer.invalidate()
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}
