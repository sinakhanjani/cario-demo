//
//  MessageViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/28/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var moreButton: RoundedButton!
    
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Actions
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        if let messageSingle = LoginService.instance.carioInit?.messageSingle {
            if messageSingle.needShow == "1" {
                self.loadViewControllerByServer(identifier: "banner", target: messageSingle.target, sender: nil)
            }
        }
        self.removeAnimate()
    }

    @IBAction func moreButtonPressed(_ sender: UIButton) {
        if let messageSingle = LoginService.instance.carioInit?.messageSingle {
            if messageSingle.hasMore == "1" {
                self.present(LongDescriptionViewController.showModal(), animated: true, completion: nil)
            }
        }
    }
    
    // Method
    func updateUI() {
        self.showAnimate()
        self.imageView.isHidden = true
        self.lottieView.isHidden = true
        self.moreButton.isHidden = true
        if let messageSingle = LoginService.instance.carioInit?.messageSingle {
            if messageSingle.isLottie == "1" {
                self.lottieView.isHidden = false
                let url = URL.init(string: messageSingle.lottieUrl)
                self.loadLottieFromURL(url: url, lottieView: self.lottieView)
            } else {
                self.imageView.isHidden = false
                let url = "http://app.cario.ir" + messageSingle.image
                self.imageView.loadImageUsingCache(withUrl: url)
            }
            if messageSingle.hasMore == "1" {
                self.moreButton.isHidden = false
            }
            self.titleLabel.text = messageSingle.title
            self.shortDescriptionLabel.text = messageSingle.shortMessage
        }
    }
    
    

}
