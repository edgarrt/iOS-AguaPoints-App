//
//  LoginViewController.swift
//  Agua
//
//  Created by Edgar Trujillo on 3/26/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SystemConfiguration

class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    var firebaseref: Firebase!
    var points = 0
    
    var connected = true
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if connectedToNetwork() == true{
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
       //     print("logged in already")
            self.dismissViewControllerAnimated(true, completion: nil )
            self.performSegueWithIdentifier("gotohome", sender: self)
            
        
        }
        }
        else{
            /*
            //not connected 
            let alert = UIAlertController(title: "No Connection", message: "Sorry, but you need to be connected to a network to use the app.", preferredStyle: UIAlertControllerStyle.Alert)
           // let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            // alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            */
            
            SweetAlert().showAlert("No Connection", subTitle: "Sorry, but you need to be connected to a network to use the app.", style: AlertStyle.None)
            
            connected = false
        }
        
}
    
    
    
    
    @IBAction func loginAction(sender: AnyObject)
    {
        
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error != nil {
             //       print(error)
                    self.loginErrorAlert("Something Went Wrong!", message: "Check your username and password.")
                } else {
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
        
            //        print("logged in")
                    
                    // Enter the app!
                    self.performSegueWithIdentifier("gotohome", sender: self)
                    }
            })
            
        } else {
            // There was a problem
            loginErrorAlert("Sorry Something Went Wrong", message: "Don't forget to enter your email and password.")
        }
        
    
    
    
    
    
}
    
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    
    
    
}



public extension UIDevice {
    
    var modelName: Int {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return 1
        case "iPod7,1":                                 return 2
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return 3
        case "iPhone4,1":                               return 4
        case "iPhone5,1", "iPhone5,2":                  return 5
        case "iPhone5,3", "iPhone5,4":                  return 6
        case "iPhone6,1", "iPhone6,2":                  return 7
        case "iPhone7,2":                               return 8
        case "iPhone7,1":                               return 9
        case "iPhone8,1":                               return 10
        case "iPhone8,2":                               return 11
        case "iPhone8,4":                               return 12
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return 13
        case "iPad3,1", "iPad3,2", "iPad3,3":           return 14
        case "iPad3,4", "iPad3,5", "iPad3,6":           return 15
        case "iPad4,1", "iPad4,2", "iPad4,3":           return 16
        case "iPad5,3", "iPad5,4":                      return 17
        case "iPad2,5", "iPad2,6", "iPad2,7":           return 18
        case "iPad4,4", "iPad4,5", "iPad4,6":           return 19
        case "iPad4,7", "iPad4,8", "iPad4,9":           return 20
        case "iPad5,1", "iPad5,2":                      return 21
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return 22
        case "AppleTV5,3":                              return 23
        case "i386", "x86_64":                          return 0
        default:                                        return 99
        }
    }
    
}
