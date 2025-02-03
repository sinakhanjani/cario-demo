//
//  NewsViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import SideMenu

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.configureSideBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let car = DataManager.shared.selectedCar {
            contentRequest(carId: car.id)
        }
    }
    
    // Action

    // Method
    func updateUI() {
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableView.automaticDimension
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        navigationItem.backBarButtonItem = backButton
    }
    
    func contentRequest(carId: String) {
       // self.startIndicatorAnimate()
        FeedService.instance.contentRequest(carId: carId) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                     //   self.stopIndicatorAnimate()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == TO_DETAIL_CONTENT_SEGUE else { return }
        let destination = segue.destination as! DetailNewsViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let content = FeedService.instance.contents[indexPath.row]
            destination.content = content
        }
    }
    

}

extension NewsViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedService.instance.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NEWS_CELL, for: indexPath) as! NewsTableViewCell
        let content = FeedService.instance.contents[indexPath.row]
        let imageURL = "http://app.cario.ir" + content.content_image
        cell.newsImageView.loadImageUsingCache(withUrl: imageURL)
        var didSeen = false
        if content.iview == "1" {
            didSeen = true
        } else {
            didSeen = false
        }
        cell.configureCell(title: content.content_title, description: content.content_text, seenNumber: content.views, likeNumber: content.clike, didSeen: didSeen)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
