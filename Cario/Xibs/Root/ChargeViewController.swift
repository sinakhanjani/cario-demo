//
//  ChargeViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ChargeViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var moneySlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Actions
    @IBAction func sliderValuChanged(_ sender: UISlider) {
        let amount = Int(moneySlider.value)
        let rounded = (amount/100 * 100).seperateByCama
        self.sliderLabel.text = "\(rounded) تومان"
    }
    
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        guard moneySlider.value != 0.0 else {
            let message = "لطفا حداقل مبلغ پرداختی را برای شارژ انتخاب نمایید "
            self.presentWarningAlert(message: message)
            return
        }
        guard moneySlider.value > 1000.0 else {
            let message = "حداقل مبلغ پرداختی هزار تومان میباشد"
            self.presentWarningAlert(message: message)
            return
        }
        let amount = Int(moneySlider.value)
        let rounded = String(amount/100 * 100)
        PaymentService.instance.chargeCredit(money: rounded)
        self.removeAnimate()
    }
    
    // Method
    func updateUI() {
        self.showAnimate()
        self.configureTouchXibViewController(bgView: bgView)
        self.priceLabel.text = "\(LoginService.instance.profileContent!.purse.seperateByCama) تومان"
    }
    

}
