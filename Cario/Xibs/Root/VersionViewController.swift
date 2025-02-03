//
//  VersionViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/28/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var messages: [String] = ["نسخه جدید برنامه موجود است، لطفا برنامه را به روز رسانی کنید !","نسخه فعلی شما دیگر قابل استفاده نمیباشد، لطفا به روز رسانی کنید."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        if let carioInit = LoginService.instance.carioInit {
            if carioInit.version.minVersion > Int(VERSION)! {
                self.descriptionLabel.text = messages[1]
                // Do not dismiss Xibs ViewController
            } else {
                self.descriptionLabel.text = messages[0]
                let touch = UITapGestureRecognizer.init(target: self, action: #selector(dismissedVersionViewController))
                self.bgView.addGestureRecognizer(touch)
            }
        }
    }
    
    // Objcs
    @objc func dismissedVersionViewController() {
        NotificationCenter.default.post(name: REMOVE_VERSION_VC, object: nil)
        self.removeAnimate()
    }

    // Action
    @IBAction func downloadButtonPressed(_ sender: RoundedButton) {
        if let carioInit = LoginService.instance.carioInit {
            let url = URL.init(string: carioInit.version.updateURL)
            WebService.instance.openURL(url: url)
        }
    }
    

}
