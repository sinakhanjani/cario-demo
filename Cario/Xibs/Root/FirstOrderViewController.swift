//
//  FirstOrderViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/28/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class FirstOrderViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        updateUI()
    }

    // Action
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        self.removeAnimate()
    }
    
    // Method
    func updateUI() {
        if let carioInit = LoginService.instance.carioInit {
            let firstOrder = carioInit.firstOrder
            let message = "با ثبت اولین سفارش در سامانه کاریو میتوانید مبلغ \(firstOrder.discount) تومان را از ما هدیه بگیرید. کد تخفیف : \(firstOrder.discountCode)"
            self.descriptionLabel.text = message
        }
    }

    
}
