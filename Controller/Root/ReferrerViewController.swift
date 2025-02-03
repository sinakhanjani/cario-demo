
//
//  ReferrerViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ReferrerViewController: UIViewController {

    @IBOutlet weak var referrerNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let userInformation = DataManager.shared.userInformation {
            let message = "کد معرف شما : \(userInformation.user_referrer_token)"
            let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = sender
            present(activityController, animated: true, completion: nil)
        }
    }
    
    // Method
    func updateUI() {
        if let userInformation = DataManager.shared.userInformation {
            self.referrerNumberLabel.text = userInformation.user_referrer_token
            if let description = LoginService.instance.carioInit?.referrerPrize {
                let replacedDescription = (description as NSString).replacingOccurrences(of: "token", with: userInformation.user_referrer_token)
                self.descriptionLabel.text = replacedDescription
            }
        }
    }
    
    
}
