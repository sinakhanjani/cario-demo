//
//  ProfileCollectionViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 7/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionButton: RoundedButton!
    
    func configureCell(name: String, number: String, image: UIImage, description: String) {
        self.imageView.image = image
        self.nameLabel.text = name
        self.numberLabel.text = number
        self.descriptionButton.setTitle(description, for: .normal)
    }
    
}
