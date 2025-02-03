//
//  BookingCategoryCollectionViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 8/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class BookingCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var centerView: RoundedView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configureCell(name: String) {
        self.nameLabel.text = name
    }
    
    
    
}
