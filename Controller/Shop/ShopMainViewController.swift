//
//  ShopMainViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ShopMainViewController: UIViewController {
    
    @IBOutlet weak var lottieView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        self.loadLottieJson(bundleName: "under_construction", lottieView: self.lottieView)
    }
    
    
}
