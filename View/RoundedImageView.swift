//
//  RoundedImageView.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        if cornerRadius > 0.0 {
           self.layer.cornerRadius = cornerRadius
        } else {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.clipsToBounds = true
        //self.layer.borderWidth = 1.7
        //self.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
}
