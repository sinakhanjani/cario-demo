//
//  EmdadKhodroTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class EmdadKhodroTableViewCell: UITableViewCell {

    @IBOutlet weak var emdadImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(image: UIImage, name: String, tel: String) {
        self.nameLabel.text = name
        self.telLabel.text = tel
        self.emdadImageView.image = image
    }
    
    
}
