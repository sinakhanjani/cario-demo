//
//  DefaultTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 7/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(subject: String, description: String) {
        self.subjectLabel.text = subject
        self.descriptionLabel.text = description
    }
    
    
}
