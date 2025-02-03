//
//  CarCollectionViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class CarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var CarLogoimageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(name: String) {
        self.nameLabel.text = name
    }
    
    
}
