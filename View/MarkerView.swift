//
//  MarkerView.swift
//  Cario
//
//  Created by Sinakhanjani on 8/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class MarkerView: UIView {
    
    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont.iranSansBoldFont(size: 13)
        lbl.textColor = UIColor.darkGray
        lbl.tintColor = UIColor.darkGray
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    init(frame: CGRect, markerTitle title: String) {
        super.init(frame: frame)
//        self.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.backgroundColor = #colorLiteral(red: 0.1286308467, green: 0.1932508349, blue: 0.2481646836, alpha: 1)
        self.layer.borderWidth = 0
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        setupViews()
        self.lblTitle.text = title
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.addSubview(lblTitle)
        lblTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
