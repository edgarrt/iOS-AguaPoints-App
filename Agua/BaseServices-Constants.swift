//
//  BaseServices.swift
//  Agua
//
//  Created by Edgar Trujillo on 3/26/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import Firebase
import UIKit

let BASE_URL = "agua-app.firebaseIO.com"

//Firebase ref
let userid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
let currentUser = Firebase(url: "\(BASE_URL)").childByAppendingPath("users").childByAppendingPath(userID)

let adcolonyAppID = "appb0846f5f66e0466794"
let adcolonyZoneID = "vz998fddbdf3f645638a"
let adcolonyZoneID2 = "vzc020cb00cde540048d"


//Dont need this..Messes things up..
let zoneOff = "zoneOff"
let zoneLoading = "ZoneLoading"
let zoneReady = "ZoneReady"

let currencyBalance = "CurrencyBalance"
let currencyBalanceChange = "CurrencyBalanceChange"


class DataService {

    
    
    
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
}
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        // A User is born.
        
        USER_REF.childByAppendingPath(uid).setValue(user)
        
        USER_REF.childByAppendingPath(uid).updateChildValues([
            "pointsEarned" :0 ])
        
        
        USER_REF.childByAppendingPath(uid).updateChildValues([
            "CurrentAdsSeen" :0 ])
        
        USER_REF.childByAppendingPath(uid).updateChildValues([
            "FacebookShare" :0 ])
        USER_REF.childByAppendingPath(uid).updateChildValues([
            "extraPoints" :0 ])
        USER_REF.childByAppendingPath(uid).updateChildValues([
            "timeStamp" :0 ])
        
        
   //     print("Account Created ")
        
    
    }

}