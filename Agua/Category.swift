//
//  Category.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/10/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import UIKit


class Category {
    let name:String
    let rewards:[Reward]
    
    
    init(name: String, rewards: [Reward]){
        self.name = name
        self.rewards = rewards
    }
}