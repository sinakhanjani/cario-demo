//
//  ContentViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var callUsContainer: UIView!
    @IBOutlet weak var defaultContainer: UIView!
    
    var disaster: Disaster?

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        callUsContainer.isHidden = true
        webViewContainer.isHidden = true
        defaultContainer.isHidden = true
        if let disaster = disaster {
            switch disaster.cardName {
            case .none:
                break
            case .pm:
                webViewContainer.isHidden = false
                //
                break
            case .aboutUs:
                defaultContainer.isHidden = false
                //
                break
            case .callUs:
                callUsContainer.isHidden = false
                //
                break
            case .question:
                defaultContainer.isHidden = false
                //
                break
            case .rateUp:
                defaultContainer.isHidden = false
                //
                break
            case .rules:
                defaultContainer.isHidden = false
                //
                break
            case .exit:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == TO_DEFAULT_VIEW_CONTROLLER_SEGUE else { return }
        let destination = segue.destination as! DefaultViewController
        guard let disaster = disaster else { return }
        destination.disaster = disaster
    }

    static func create() -> ContentViewController {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: CONTENT_VIEW_CONTROLLER_ID) as! ContentViewController
    }

    
}

