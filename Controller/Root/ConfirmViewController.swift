//
//  ConfirmViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var mobileLabel: UILabel!
    
    @IBOutlet weak var referrerCodeTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    fileprivate let defaults = UserDefaults(suiteName: USER_DEFAULT_KEY)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        guard let code = codeTextField.text, codeTextField.text != "" else {
            let message = "لطفا کد تایید را وارد کنید"
            self.presentWarningAlert(message: message)
            return
        }
        let referrerCode = referrerCodeTextField.text
        self.view.endEditing(true)
        self.startIndicatorAnimate()
        LoginService.instance.activationCode(mobileNumber: LoginService.instance.mobileNumber, codeNumber: code, referrer: referrerCode) { (status) in
            self.webServiceAlert(withType: status, escape: { (_) in
                if status == .success {
                    self.defaults.set(true, forKey: PRESENT_REGISTER_VC_KEY)
                    DispatchQueue.main.async {
                        if let userHistory = LoginService.instance.userhistory {
                            if userHistory == .new {
                                CarService.instance.getAllCarRequest(completion: { (status) in
                                    self.webServiceAlert(withType: status, escape: { (status) in
                                        if status == .success {
                                            DispatchQueue.main.async {
                                                self.stopIndicatorAnimate()
                                                self.present(AddCarViewController.showModal(), animated: true, completion: nil)
                                            }
                                        }
                                    })
                                })
                            } else {
                                self.stopIndicatorAnimate()
                                self.defaults.set(true, forKey: PRESENT_ADD_CAR_KEY)
                                self.performSegue(withIdentifier: CONFIRM_TO_LOADER_SEGUE, sender: sender)
                            }
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func resendCodeButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
        //
    }
    
    // Method
    func updateUI() {
        self.dismissesKeyboardByTouch()
        codeTextField.keyboardType = .asciiCapableNumberPad
        self.mobileLabel.text = LoginService.instance.mobileNumber
        if let userHistory = LoginService.instance.userhistory {
            if userHistory == .new {
                self.referrerCodeTextField.isHidden = false
                self.referrerCodeTextField.isHidden = false
                self.iconImageView.isHidden = false
                self.lineView.isHidden = false
                self.buttonTopConstraint.constant = 60.0
            } else {
                self.referrerCodeTextField.isHidden = true
                self.iconImageView.isHidden = true
                self.lineView.isHidden = true
                self.buttonTopConstraint.constant = 16.0
            }
        }
    }

    

}
