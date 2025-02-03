//
//  DetailNewsViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isLikedButton: RoundedButton!
    @IBOutlet weak var goUpButton: RoundedButton!
    
    var content: Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func isLikedButtonPressed(_ sender: RoundedButton) {
        if let content = content {
            var isLike: Bool = false
            if self.isLikedButton.image(for: .normal) == UIImage.init(named: "content_like") {
                self.isLikedButton.setImage(UIImage.init(named: "content_liked"), for: .normal)
                isLike = true
            } else {
                self.isLikedButton.setImage(UIImage.init(named: "content_like"), for: .normal)
                isLike = false
            }
            self.likeRequestSend(contentId: content.content_id, isLiked: isLike)
        }
    }
    
    @IBAction func goUpButtonPressed(_ sender: RoundedButton) {
        scrollView.scrollsToTop = true
        let position = CGPoint(x: 0, y: scrollView.contentInset.top)
        scrollView.setContentOffset(position, animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: RoundedButton) {
        guard let message = descriptionLabel.text, descriptionLabel.text != "" else { return }
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        updateContent()
        self.goUpButton.isHidden = true
        if descriptionLabel.text!.count > 400 {
            self.goUpButton.isHidden = false
        }
    }
    
    func updateContent() {
        if let content = content {
            self.titleLabel.text = content.content_title
            self.descriptionLabel.text = content.content_text
            let imageURL = "http://app.cario.ir" + content.content_image
            self.imageView.loadImageUsingCache(withUrl: imageURL)
            if content.ilike == "1" {
                self.isLikedButton.setImage(UIImage.init(named: "content_liked"), for: .normal)
            } else {
                self.isLikedButton.setImage(UIImage.init(named: "content_like"), for: .normal)
            }
            self.descriptionLabel.sizeToFit()
            seenComplete(contentId: content.content_id)
        }
    }
    
    func seenComplete(contentId: String) {
        FeedService.instance.contentViewRequest(contentId: contentId) { (status) in
            self.webServiceAlert(withType: status, escape: { (satatus) in
                if status == .success {
                    //
                }
            })
        }
    }
    
    func likeRequestSend(contentId: String, isLiked: Bool) {
        FeedService.instance.contentLikeRequest(contentId: contentId, isLiked: isLiked) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    //
                }
            })
        }
    }
    
    
}
