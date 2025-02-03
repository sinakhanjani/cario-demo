//
//  NearTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 8/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol NearTableViewCellDelegate {
    func buttonPressed(cell: NearTableViewCell)
}

class NearTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: RoundedImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    var delegate: NearTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreDetailButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(cell: self)
    }
    
    func configureCell(name: String, detail: String) {
        self.nameLabel.text = name
        self.detailLabel.text = detail
    }
    
}
