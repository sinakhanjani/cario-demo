//
//  WebViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        webView.delegate = self
        webView.allowsLinkPreview = true
        requestBaseURL()
    }
    
    func requestBaseURL() {
        guard let url = URL(string: BASE_URL + "news") else { return }
        let request = URLRequest.init(url: url)
        webView.loadRequest(request)
    }
    
}
