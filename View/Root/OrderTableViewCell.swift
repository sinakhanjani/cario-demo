//
//  OrderTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 8/2/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var priceTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(serviceName: String, detail: String, priceType: String, price: Int, wage: String, discount: String, whyDiscount: String, applyDiscount: String, enable: String, whyDisable: String) {
        self.serviceNameLabel.text = serviceName
        self.detailLabel.text = detail
        // priceLabel
        if priceType == "1" {
            var finalPrice = price
            if wage != "0" {
                finalPrice += Int(wage)!
            }
            if applyDiscount == "1" {
                finalPrice -= Int(discount)!
            }
            self.priceTypeLabel.text = "قیمت : \(finalPrice.seperateByCama)"
        } else {
            self.priceTypeLabel.text = "قیمت : توافقی"
        }
        // detailLabel
        if applyDiscount == "1" {
            self.detailLabel.text = self.detailLabel.text! + "\n" + whyDiscount + " | " + "مبلغ تخفیف : \(discount)"
        }
        if wage != "0" {
            self.detailLabel.text = self.detailLabel.text! + "\n" + "هزینه اجرت : \(wage.seperateByCama) تومان"
        }
        if enable != "1" {
            self.detailLabel.text = whyDisable
        }
    }
    

}
