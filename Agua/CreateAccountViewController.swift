//
//  CreateAccountViewController.swift
//  Agua
//
//  Created by Edgar Trujillo on 3/26/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import UIKit
import Firebase

import Foundation

class CreateAccountViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBAction func createAccountAction(sender: AnyObject) {
  
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            
            // Set Email and Password for the New User.
            
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                } else {
                    
                    // Create and Login the New User with authUser
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        
                        let user = ["provider": authData.provider!,
                                    "email": email!,
                                    "online": "off"]
                        
                        // Seal the deal in DataService.swift.
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                    
                    // Enter the app.
                    self.performSegueWithIdentifier("gotohome", sender: self)
                    self.dismissViewControllerAnimated(true , completion: nil )
                    
                    
                }
            })
            
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
        
    }

        
        
        
        

    
    
func signupErrorAlert(title: String, message: String) {
    
    // Called upon signup error to let the user know signup didn't work.
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
}




    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}



