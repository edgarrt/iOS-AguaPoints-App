//
//  Reward.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/5/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation

class Reward {
    let name:String
    let image:String
    let description:String
    let price:Int
    
    init(name: String, image:String, description:String, price:Int){
        self.name = name
        self.image = image
        self.description = description
        self.price = price
}
}