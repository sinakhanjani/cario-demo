
//
//  ProfileTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 7/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerDescriptionLabel: UILabel!
    @IBOutlet weak var packeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var slakeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var packageImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(providerName: String, providerDescription: String, packName: String, price: String, slake: String, date: String, time: String) {
        self.providerNameLabel.text = providerName
        self.providerDescriptionLabel.text = providerDescription
        self.packeLabel.text = packName
        self.priceLabel.text = price
        if let slakeNumber = Int(slake), slakeNumber <= 100 {
            let disCount = Int(price)! - (slakeNumber * Int(price)!) / 100
            self.slakeLabel.text = disCount.seperateByCama
        } else {
            self.slakeLabel.text = slake
        }
        self.dateLabel.text = date
        self.timeLabel.text = time
    }
    
    
}
