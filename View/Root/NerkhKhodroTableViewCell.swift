//
//  NerkhKhodroTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class NerkhKhodroTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var bazarPriceLabel: UILabel!
    @IBOutlet weak var namayandegiPriceLabel: UILabel!
    @IBOutlet weak var agentChangeLabel: UILabel!
    @IBOutlet weak var marketChangeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(carName: String, detail: String, bazarPrice: String, namayeshgahPrice: String, agentChanged: String, markerChanged: String, date: String, year: String) {
        self.carNameLabel.text = carName
        self.detailLabel.text = detail
        self.bazarPriceLabel.text = bazarPrice
        self.namayandegiPriceLabel.text = namayeshgahPrice
        self.agentChangeLabel.text = agentChanged
        self.marketChangeLabel.text = markerChanged
        self.dateLabel.text = date
        self.yearLabel.text = year
    }

}
