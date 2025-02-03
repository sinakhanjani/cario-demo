//
//  MarkerIconView.swift
//  Cario
//
//  Created by Sinakhanjani on 8/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class MarkerIconView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        let imgView = UIImageView()
        //imgView.image = UIImage.init(named: "")
        imgView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.clipsToBounds = true
        self.addSubview(imgView)
        self.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
