//
//  NomrehManfiViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class NomrehManfiViewController: UIViewController {

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
