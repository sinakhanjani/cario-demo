//
//  CarServiceCollectionViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 7/29/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CarServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var badgeNumberLabel: UILabel!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var bannerImageView: RoundedImageView!
    
    override func awakeFromNib() {
        self.bannerImageView.alpha = 0.0
    }
    
    func configureCell(name: String, detail: String, badgeNumber: String?) {
        self.nameLabel.text = name
        self.detailLabel.text = detail
        if let badgeNumber = badgeNumber {
            self.badgeNumberLabel.text = badgeNumber
        } else {
            badgeView.isHidden = true
        }
    }
    
}
