//
//  KhalafiViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/29/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class KhalafiViewController: UIViewController {
    
    var titleHeader: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        self.title = titleHeader
    }
    
    
}
