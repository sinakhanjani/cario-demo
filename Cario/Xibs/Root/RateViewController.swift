//
//  RateViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var ratingStackView: RatingStackView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var rateDetail: (orderId: String, condition: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let description = descriptionTextField.text, descriptionTextField.text != "" else {
            let message = "لطفا نظر خود را بنویسید"
            self.presentWarningAlert(message: message)
            return
        }
        guard ratingStackView.rating != 0 else {
            let message = "لطفا یک امتیاز ثبت کنید"
            self.presentWarningAlert(message: message)
            return
        }
        if let rateDetail = rateDetail {
            self.startIndicatorAnimate()
            FeedService.instance.feedBackRequest(feedRate: ratingStackView.rating, feedCondition: rateDetail.condition, message: description, orderId: rateDetail.orderId) { (status) in
                self.webServiceAlert(withType: status, escape: { (status) in
                    if status == .success {
                        DispatchQueue.main.async {
                            self.stopIndicatorAnimate()
                            self.removeAnimate()
                            NotificationCenter.default.post(name: PRESNET_WARNING_ORDER_VC_NOTIFY, object: nil)
                        }
                    }
                })
            }
        }
    }
    
    // Method
    func updateUI() {
        self.showAnimate()
        self.dismissesKeyboardByTouch()
        configureTouchXibViewController(bgView: bgView)
    }
    
    
}
