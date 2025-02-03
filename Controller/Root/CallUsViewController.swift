
//
//  CallUsViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class CallUsViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func emailButtonPressed(_ sender: RoundedButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Can not send email")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.delegate = self
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["support@cario.ir"])
        mailComposer.setSubject("تماس با پشتیبانی کاریو")
        mailComposer.setMessageBody("", isHTML: false)
        present(mailComposer, animated: true, completion: nil)
    }

    @IBAction func telegramButtonPressed(_ sender: RoundedButton) {
        let url = URL.init(string: "http://t.me/cario_support")
        WebService.instance.openURL(url: url)
    }
    
    @IBAction func callButtonPressed(_ sender: RoundedButton) {
        let telURL = "tel://\(0218428855)"
        if let url = URL(string: telURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    // Method
    func updateUI() {
        //
    }
    
    // dismissed mail sending
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("dismissed mail composer")
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension CallUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CALL_US_CELL, for: indexPath)
        return cell
    }
    
    
}
