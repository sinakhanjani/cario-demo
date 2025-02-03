//
//  SideBarTableViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import CDAlertView

class SideBarTableViewController: UITableViewController {

    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    
    private var previousIndex: NSIndexPath?
    private var pageMenuIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    // Objc
    @objc func fetchProfileUp() {
        DispatchQueue.main.async {
            if let profileContent = LoginService.instance.profileContent {
                self.rateLabel.text = profileContent.rating
                self.creditLabel.text = profileContent.purse.seperateByCama
            }
        }
    }
    
    // Actions
    @IBAction func referrerButtonPressed(_ sender: RoundedButton) {
        //
    }
    
    // Method
    func updateUI() {
        self.loadLottieJson(bundleName: "lootie_splash", lottieView: lottieView)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchProfileUp), name: UPDATE_PROFILE_NOTIFY, object: nil)
        if let profileContent = LoginService.instance.profileContent {
            self.rateLabel.text = profileContent.rating
            self.creditLabel.text = profileContent.purse.seperateByCama
        }
    }

    // TableView - Data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        previousIndex = indexPath as NSIndexPath?
        let index = indexPath.row
        switch index {
        case 1:
            break
        case 2:
            self.pageMenuIndex = 5
            performSegue(withIdentifier: SIDEBAR_SEGUE, sender: SideMenuItem.pm)
        case 3:
            self.pageMenuIndex = 4
            performSegue(withIdentifier: SIDEBAR_SEGUE, sender: SideMenuItem.aboutUs)
            break
        case 4:
            self.pageMenuIndex = 3
            performSegue(withIdentifier: SIDEBAR_SEGUE, sender: SideMenuItem.callUs)
            break
        case 5:
            self.pageMenuIndex = 2
            performSegue(withIdentifier: SIDEBAR_SEGUE, sender: SideMenuItem.question)
            break
        case 6:
            self.pageMenuIndex = 0
            performSegue(withIdentifier: SIDEBAR_SEGUE, sender: SideMenuItem.rules)
            break
        case 7:
            let message = "اپلیکیشن کاریو !"
            let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        case 8:
            exitProfile()
        default:
            break
        }
    }
    
    private func exitProfile() {
        let alert = CDAlertView(title: "توجه !", message: "آیا میخواهید از پروفایل کاربری خود خارج شوید ؟", type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!
        alert.messageFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 14)!
        let done = CDAlertViewAction(title: "بله", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (action) -> Bool in
            Authentication.auth.logOutAuth()
            print("logout button pressed !")
            self.present(RegistrerationViewController.showModal(), animated: true, completion: nil)
            return true
        }
        let cancel = CDAlertViewAction(title: "خیر", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white, handler: nil)
        alert.add(action: done)
        alert.add(action: cancel)
        alert.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SIDEBAR_SEGUE else { return }
        let destination = segue.destination as! UINavigationController
        let segmentioViewController = destination.viewControllers.first as! SegmentioViewController
        segmentioViewController.selectedSegmentioIndex = pageMenuIndex
    }
    
    
}
