//
//  NewsTableViewCell.swift
//  Cario
//
//  Created by Sinakhanjani on 7/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seenNumberLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var seenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(title: String, description: String, seenNumber: String, likeNumber: String, didSeen: Bool) {
        if didSeen {
            seenImageView.isHidden = false
        } else {
            seenImageView.isHidden = true
        }
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.seenNumberLabel.text = seenNumber
        self.likeNumberLabel.text = likeNumber
    }
    
}
