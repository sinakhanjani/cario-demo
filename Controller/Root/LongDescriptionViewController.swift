//
//  LongDescriptionViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/29/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LongDescriptionViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    

    // Method
    func updateUI() {
        if let messageSinge = LoginService.instance.carioInit?.messageSingle {
            self.titleLabel.text = messageSinge.title
            self.descriptionLabel.text = messageSinge.message
        }
    }
    
    static func showModal() -> UINavigationController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: DESCRIPTION_VIEW_CONTROLLER_ID) as! UINavigationController
    }
    

}
