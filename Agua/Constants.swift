//
//  Constants.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/13/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//


struct Constants
{
    let userid = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
static let adcolonyAppID = "appb0846f5f66e0466794"
static let adcolonyZoneID = "vz998fddbdf3f645638a"
static let adcolonyZoneID2 = "vzc020cb00cde540048d"

    
    //Dont need this..Messes things up..
static let zoneOff = "zoneOff"
static let zoneLoading = "ZoneLoading"
static let zoneReady = "ZoneReady"

static let currencyBalance = "CurrencyBalance"
static let currencyBalanceChange = "CurrencyBalanceChange"

}