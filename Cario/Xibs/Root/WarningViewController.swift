//
//  WarningViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Method
    func updateUI() {
        self.showAnimate()
        configureTouchXibViewController(bgView: bgView)
        self.loadLottieJson(bundleName: "wallet", lottieView: lottieView)
        self.numberLabel.text = LoginService.instance.profileContent?.rating
        if let rate = FeedService.instance.rate {
            self.descriptionLabel.text = rate.message
            if !rate.rate.isEmpty {
                guard rate.price != 0 else { return }
                self.rateLabel.text = "تبریک! \(rate.rate) امتیاز به شما تعلق گرفت !"
                self.numberLabel.text = String(rate.price + Int(LoginService.instance.profileContent!.rating)!)
            } else {
                self.rateLabel.text = ""
            }
        }
    }
    
    

}
