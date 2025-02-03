//
//  SuggestionViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var suggestionTextView: UITextView!
    @IBOutlet weak var agreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        guard let message = suggestionTextView.text, suggestionTextView.text != "" else {
            let message = "لطفا نطر خود را وارد کنید !"
            self.presentWarningAlert(message: message)
            return
        }
        self.view.endEditing(true)
        self.startIndicatorAnimate()
        FeedService.instance.feedBackService(message: message) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        let message = "نظر شما با موفقیت ارسال شد"
                        self.presentWarningAlert(message: message)
                        self.suggestionTextView.text = ""
                    }
                }
            })
        }
    }
    
    // Method
    func updateUI() {
        self.dismissesKeyboardByTouch()
        suggestionTextView.font = UIFont.iranSansFont(size: 16)
        self.suggestionTextView.delegate = self
        agreeButton.bindToKeyboard()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
}
