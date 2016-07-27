//
//  DataModel.swift
//  Agua Points
//
//  Created by Edgar Trujillo on 5/5/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation

class DataModel {
    static let sharedInstance = DataModel()
    let categories:[Category]
    
    init(){
        
        // contest
        let amazon = Reward(name: "Amazon $50 Giftcard", image: "Amazon.jpg" , description: "Enter this contest to be elgible to win a $50 Amazon Giftcard. This contest starts May 17th and will end on July 17th. Every entry will cost 5 points and one can have as many entries as they like. Winners will be anounced on July 17th and contacted by email upon winning.", price: 5)
        let gopro = Reward(name: "GoPro HERO", image: "goprohero.jpg",description: "This contest starts June 1st and will end on August 23rd.Every entry will cost 10 points and one can have as many entries as they like. Winners will be anounced on August 23rd and contacted by email upon winning. ", price:10)
        let nixon = Reward(name: "Nixon Watch", image: "nixonlogo.jpg", description: "This contest starts June 1st and will end on August 23rd.Every entry will cost 10 points and one can have as many entries as they like. Winners will be anounced on August 23rd and contacted by email upon winning.",price:10 )
        let ps4 = Reward(name: "PlayStation 4", image: "ps4.jpg", description: "This contest starts July 1st and will end on September 1st. Every entry will cost 10 points and one can have as many entries as they like. Winners will be anounced on September 1st and contacted by email upon winning.",price:10)
        let sephora = Reward(name: "Sephora $50 Giftcard", image: "SephoraCard.png", description: "Enter this contest to be elgible to win a $50 Sephora Giftcard. This contest starts May 17th and will end on July 17th. Every entry will cost 5 points and one can have as many entries as they like. Winners will be anounced on July 17th and contacted by email upon winning.",price:5)
        let ulta = Reward(name: "Ulta $50 Giftcard", image: "ulta.jpg", description: "Enter this contest to be elgible to win a $50 Ulta Giftcard. This contest starts May 17th and will end on July 17th. Every entry will cost 5 points and one can have as many entries as they like. Winners will be anounced on July 17th and contacted by email upon winning.",price:5)
        let contest = Category(name: "Contest", rewards: [amazon,sephora, ulta, gopro, nixon, ps4])
        
        // online
        let amazon2 = Reward(name: "Amazon $10 Giftcard", image: "Amazon.jpg", description: "Redeem this reward for a $10 giftcard to Amazon. Prizes will be emailed to the email you used to sign in.",price:1500)
        let best = Reward(name: "Best Buy $20 Giftcard", image: "bestbuy.png", description: "Redeem this reward for a $20 giftcard to Bestbuy. Prizes will be emailed to the email you used to sign in.",price:2500)
        let nike = Reward(name: "Nike $25 Giftcard", image: "NikeCard.png", description: "Redeem this reward for a $25 giftcard to Nike. Prizes will be emailed to the email you used to sign in..",price:3000)
        let playstation = Reward(name: "Playstation $10 Giftcard", image: "PlayStationCard.jpg", description: "Redeem this reward for a $10 giftcard to the PLaystation Store. Prizes will be emailed to the email you used to sign in.",price:1500)
        let sephora2 = Reward(name: "Sephora $25 Giftcard", image: "SephoraCard.png", description: "Redeem this reward for a $25 giftcard to Sephora. Prizes will be emailed to the email you used to sign in.",price:3000)
        let vs = Reward(name: "Victoria Secrets $25 Giftcard", image: "VictoriaSecretsCard.png", description: "Redeem this reward for a $25 giftcard to Victoria Secrets. Prizes will be emailed to the email you used to sign in.",price:3000)
        let kohls = Reward(name: "Kohl's $15 Giftcard", image: "kohls.gif", description: "Redeem this reward for a $15 giftcard to Kohl's. Prizes will be emailed to the email you used to sign in.",price:2000)
        let regals = Reward(name: "Regal $10 Giftcard", image: "regal.png", description: "Redeem this reward for a $10 giftcard to Regal Cinemas. Prizes will be emailed to the email you used to sign in.",price:1500)
        let target = Reward(name: "Target $10 Giftcard", image: "target.png", description: "Redeem this reward for a $10 giftcard to Target. Prizes will be emailed to the email you used to sign in.",price:1500)
        let walmart = Reward(name: "Walmart $10 Giftcard", image: "Walmart.jpg", description: "Redeem this reward for a $10 giftcard to Walmart. Prizes will be emailed to the email you used to sign in.",price:1500)
        let gamestop = Reward(name: "Gamestop $15 Giftcard", image: "gamestop.jpg", description: "Redeem this reward for a $15 giftcard to Gamestop. Prizes will be emailed to the email you used to sign in.",price:2000)
        let locker = Reward(name: "Footlocker $10 Giftcard", image: "locker.png", description: "Redeem this reward for a $10 giftcard to Footlocker. Prizes will be emailed to the email you used to sign in.",price:1500)
        
        let lowes = Reward(name: "Lowes $20 Giftcard", image: "lowes.jpeg", description: "Redeem this reward for a $20 giftcard to Lowes. Prizes will be emailed to the email you used to sign in.",price:2500)
        let xbox = Reward(name: "Xbox live $10 Giftcard", image: "XboxCard.gif", description: "Redeem this reward for a $10 giftcard to Xbox Live Store. Prizes will be emailed to the email you used to sign in.",price:1500)
        let online = Category(name: "Online Giftcards", rewards: [amazon2, best, nike, playstation, kohls, regals, sephora2, vs,target, walmart, locker, gamestop, lowes,xbox])
        
        // restaurant
        let applebees = Reward(name: "Applebees $20 Giftcard", image: "ApplebeesCard.jpg",description: "Redeem this reward for a $20 giftcard to Applebees. Prizes will be emailed to the email you used to sign in.",price:2500)
        let ihop = Reward(name: "iHop $10 Giftcard", image: "ihop.png", description: "Redeem this reward for a $10 giftcard to iHop. Prizes will be emailed to the email you used to sign in.",price:1500)
        let buffalo = Reward(name: "Buffalo Wild Wings $20 Giftcard", image: "Buffalo.png", description: "Redeem this reward for a $20 giftcard to Buffalo Wild Wings. Prizes will be emailed to the email you used to sign in.",price:2500)
        let busters = Reward(name: "Dave & Busters $15 Giftcard", image: "dave.png", description: "Redeem this reward for a $15 giftcard to Dave & Busters. Prizes will be emailed to the email you used to sign in.",price:2000)
        let coldstone = Reward(name: "Cold Stone $10 Giftcard", image: "coldstone.png", description: "Redeem this reward for a $10 giftcard to Kohl's. Prizes will be emailed to the email you used to sign in.",price:1500)
        let panera = Reward(name: "Panera $25 Giftcard", image: "panera.jpeg", description: "Redeem this reward for a $25 giftcard to Panera. Prizes will be emailed to the email you used to sign in.",price:3000)
        let red = Reward(name: "Red Lobster $15 Giftcard", image: "redlobster.png", description: "Redeem this reward for a $15 giftcard to Red Lobster. Prizes will be emailed to the email you used to sign in.",price:2000)
        let inNout = Reward(name: "In-N-Out $15 Giftcard", image: "InNoutCard.png", description: "Redeem this reward for a $15 giftcard to In-N-Out. Prizes will be emailed to the email you used to sign in.",price:2000)
        let robin = Reward(name: "Red Robin $20 Giftcard", image: "robin.png", description: "Redeem this reward for a $20 giftcard to Red Robin. Prizes will be emailed to the email you used to sign in.",price:2500)
        let olive = Reward(name: "Olive Garden $20 Giftcard", image: "OliveGardenCard.jpg", description: "Redeem this rewards for a giftcard.",price:2500)
        let pizza = Reward(name: "PizzaHut $15 Giftcard", image: "PizzahutCard.jpg", description: "Redeem this reward for a $15 giftcard to Pizza Hut. Prizes will be emailed to the email you used to sign in.",price:2000)
        let starbucks = Reward(name: "Starbucks $10 Giftcard", image: "StarbucksCard.png", description: "Redeem this reward for a $10 giftcard to Starbucks. Prizes will be emailed to the email you used to sign in.",price:1500)
        let restaurant = Category(name: "Restaurant Giftcards", rewards: [applebees, ihop, coldstone, busters, buffalo, red, inNout, robin, olive, pizza, panera, starbucks])
       
        /*
        // products
        let starter = Reward(name: "Starter Sport Set", image: "starter.jpg")
        let penny = Reward(name: "Pennyboard", image: "penny.jpg")
        let products = Category(name: "Products", rewards: [starter, penny])
        */
        categories = [contest, online, restaurant, /*products*/]
    }
    
}
