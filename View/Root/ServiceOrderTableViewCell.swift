//
//  ServiceOrderTableViewCell.swift
//  Cario
//
//  Created by Teodik Abrami on 10/21/18.
//  Copyright © 2018 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol ServiceOrderTableViewCellDelegate {
    func buttonPressed(cell: ServiceOrderTableViewCell)
    func areaButtonPressed(cell: ServiceOrderTableViewCell)
}

class ServiceOrderTableViewCell: UITableViewCell {
    

    @IBOutlet weak var agreedButton: UIButton!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var rateNumberLabel: UILabel!
    @IBOutlet weak var bottomColoringView: UIView!
    var delegate: ServiceOrderTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func conifigureCell(providerName: String, serviceName: String, profileImageURL: String, rateNumber: String, agreeButtonStatus: Bool) {
        self.providerNameLabel.text = providerName
        self.serviceNameLabel.text = serviceName
        let url = "http://app.cario.ir" + profileImageURL
        self.profileImageView.loadImageUsingCache(withUrl: url)
        self.rateNumberLabel.text = rateNumber
        self.agreedButton.isEnabled = agreeButtonStatus
        if agreeButtonStatus {
            self.agreedButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self.bottomColoringView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
    }
    
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(cell: self)
    }

    @IBAction func areaButtonPressed(_ sender: UIButton) {
        delegate?.areaButtonPressed(cell: self)
    }
}
