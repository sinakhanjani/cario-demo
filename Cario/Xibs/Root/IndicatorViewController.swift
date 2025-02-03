//
//  IndicatorViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class IndicatorViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lottieView: RoundedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Objc
    @objc func dismissIndicatorViewController() {
        self.removeAnimate()
    }
    
    // Method
    func updateUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissIndicatorViewController), name: DISMISS_INDICATOR_VC_NOTIFY, object: nil)
        self.showAnimate()
        loadLottieJson(bundleName: "lottie_progress", lottieView: lottieView)
    }



}
