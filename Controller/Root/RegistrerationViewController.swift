//
//  RegistrerationViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class RegistrerationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sexualSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Objc
    
    // Actions
    @IBAction func policyButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let rulesNavigationController = SegmentioViewController.showModal()
        let rulesViewController = rulesNavigationController.viewControllers.first as! SegmentioViewController
        rulesViewController.selectedSegmentioIndex = 0
        self.present(rulesNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        guard let name = nameTextField.text, let mobileNumber = mobileTextField.text, let email = emailTextField.text else { return }
        guard self.phoneNumberCondition(phoneNumber: mobileNumber) else { return }
        guard !nameTextField.text!.isEmpty && !emailTextField.text!.isEmpty else {
            let message = "لطفا تمامی اطلاعات را پر کنید"
            self.presentWarningAlert(message: message)
            return
        }
        let sexual = sexualSwitch.isOn ? Sexual.female:Sexual.male
        self.view.endEditing(true)
        self.startIndicatorAnimate()
        LoginService.instance.registrationRequest(mobileNumber: mobileNumber, userName: name, userEmail: email, sexual: sexual) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.performSegue(withIdentifier: REGISTRATION_TO_CONFIRM_SEGUE, sender: sender)
                    }
                }
            })
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //
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
        dismissesKeyboardByTouch()
        mobileTextField.keyboardType = .asciiCapableNumberPad
        mobileTextField.delegate = self
    }
    
    static func showModal() -> RegistrerationViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registrationViewController = storyBoard.instantiateViewController(withIdentifier: REGISTRATION_VIEW_CONTROLLER_ID) as! RegistrerationViewController
        return registrationViewController
    }
    
    
    
}
