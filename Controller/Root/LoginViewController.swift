//
//  LoginViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mobileTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Actions
    @IBAction func policyButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let rulesNavigationController = SegmentioViewController.showModal()
        let rulesViewController = rulesNavigationController.viewControllers.first as! SegmentioViewController
        rulesViewController.selectedSegmentioIndex = 0
        self.present(rulesNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: RoundedButton) {
        guard let mobile = mobileTextField.text else { return }
        guard self.phoneNumberCondition(phoneNumber: mobile) else { return }
        self.view.endEditing(true)
        self.startIndicatorAnimate()
        LoginService.instance.loginRequest(mobileNumber: mobile) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    self.stopIndicatorAnimate()
                    self.performSegue(withIdentifier: LOGIN_TO_CONFIRM_SEGUE, sender: sender)
                }
            })
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    // Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
    }
    func updateUI() {
        self.dismissesKeyboardByTouch()
        mobileTextField.delegate = self
    }

}
