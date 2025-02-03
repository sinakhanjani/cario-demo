//
//  PaymentViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/4/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    
    var orderId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func creditButtonPressed(_ sender: RoundedButton) {
        guard let orderId = orderId else { return }
        self.startIndicatorAnimate()
        OrderService.instance.payFromPurse(orderId: orderId) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        NotificationCenter.default.post(name: CHECK_COMPLETE_ORDER_SUBMIT, object: nil)
                        self.removeAnimate()
                    }
                }
            })
        }
    }
    
    @IBAction func onlineButtonPressed(_ sender: RoundedButton) {
        guard let orderId = orderId else { return }
        OrderService.instance.payFromBank(orderId: orderId)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            NotificationCenter.default.post(name: CHECK_COMPLETE_ORDER_SUBMIT, object: nil)
            self.removeAnimate()
        }
    }
    
    // Method
    func updateUI() {
        self.configureTouchXibViewController(bgView: self.bgView)
    }
    
    

}
