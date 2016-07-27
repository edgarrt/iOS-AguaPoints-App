//
//  ccell.swift
//  Agua
//
//  Created by Edgar Trujillo on 4/12/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import UIKit

class ccell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var ptsView: UILabel!
    
    
    var reward:Reward? = nil {
        didSet {
            if let reward = reward{
                imageView.image = UIImage(named: reward.image)
                labelView.text = "\(reward.name)"
                ptsView.text = "\(reward.price)"
                
        }
    }
}
}