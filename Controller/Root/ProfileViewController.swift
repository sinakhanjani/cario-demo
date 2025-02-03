//
//  ProfileViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var svgProfileView: RoundedView!
    @IBOutlet weak var roundView: RoundedView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableView: UIView!
    @IBOutlet weak var showButton: RoundedButton!
    
    var orderObject: [OrderObjcet]? {
        return LoginService.instance.profileContent?.orderObject
    }
    
    fileprivate var expandable: Exapandable = .unExpand {
        willSet {
            var message = ""
            if newValue == .expand {
                message = "بستن لیست سفارشات"
                if let _ = orderObject {
                    self.expandableView.isHidden = true
                }
            } else {
                message = "مشاهده تمام سفارشات"
                self.expandableView.isHidden = false
            }
            self.autoDimensionScrollViewHeight()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.showButton.setTitle(message, for: .normal)
                self.tableView.reloadInputViews()
                self.tableView.reloadData()
            }
        }
    }
    fileprivate var collectionSource: [(name: String, number: String, description: String, image: UIImage)] = [(name: "تومان", number: LoginService.instance.profileContent!.purse.seperateByCama, description: "افزایش اعتبار کیف پول", image: UIImage.init(named: "wallet")!),
                                                                                                               (name: "امتیاز", number: LoginService.instance.profileContent!.rating, description: "افزایش امتیاز", image: UIImage.init(named: "point")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    // Objc
    @objc func fetchProfileUp() {
        guard Authentication.auth.isLoggedIn else { return }
        LoginService.instance.profileUpRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == . success {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.autoDimensionScrollViewHeight()
                    }
                }
            })
        }
    }
    
    @objc func presentWarningOrder() {
        self.presentWarningViewController()
    }
    
    // Action
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expandableButtonPressed(_ sender: RoundedButton) {
        if expandable == .expand {
            expandable = .unExpand
        } else {
            expandable = .expand
        }
    }
    
    @IBAction func rateButtonPressed(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else { return }
        if let orderObject = orderObject {
            let order = orderObject[indexPath.row]
            var condition: String
            if sender.title(for: .normal) == "بلـه" {
                condition = "1"
            } else {
                condition = "2"
            }
            let rateDetail: (orderId: String, condition: String) = (orderId: order.id, condition: condition)
            self.presentRateViewController(rateDetail: rateDetail)
        }
    }
    
    // Method
    func updateUI() {
        configureProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchProfileUp), name: UPDATE_PROFILE_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentWarningOrder), name: PRESNET_WARNING_ORDER_VC_NOTIFY, object: nil)
        NotificationCenter.default.post(name: UPDATE_PROFILE_NOTIFY, object: nil)
        autoDimensionScrollViewHeight()
    }
    
    func configureProfile() {
        if let profileContent = LoginService.instance.profileContent {
            if profileContent.gender == "1" {
                self.profileImageView.image = UIImage(named: "avatar_man")
            } else {
                self.profileImageView.image = UIImage(named: "avatar_woman")
            }
            self.nameLabel.text = profileContent.fname
        }
        loadLottieJson(bundleName: "point", lottieView: roundView)
    }
    
    func autoDimensionScrollViewHeight() {
        UIView.animate(withDuration: 0, animations: {
            self.tableView.layoutIfNeeded()
        }) { (complete) in
            var heightOfTableView: CGFloat = 0.0
            // Get visible cells and sum up their heights
            /*
            let cells = self.tableView.visibleCells
            for cell in cells {
                heightOfTableView += cell.frame.height
            }
            */
            if let orderObject = self.orderObject {
                let count = (self.expandable == .unExpand) ? 1:orderObject.count
                heightOfTableView = CGFloat(count) * self.tableView.rowHeight
            } else {
                heightOfTableView = -80.0
            }
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.scrollHeightConstraint.constant = heightOfTableView + 220.0
            self.configureShowAllButton()
        }
    }
    
    func configureShowAllButton() {
        if let orderObject = orderObject {
            if orderObject.isEmpty {
                self.expandableView.isHidden = true
            }
            if orderObject.count == 1 {
                self.expandableView.isHidden = true
            }
        }
    }
    

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PROFILE_COLLECTION_CELL, for: indexPath) as! ProfileCollectionViewCell
        let source = collectionSource[indexPath.row]
        cell.configureCell(name: source.name, number: source.number, image: source.image, description: source.description)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            self.presentChargeViewController()
            break
        case 1:
            let rulesNavigationController = SegmentioViewController.showModal()
            let rulesViewController = rulesNavigationController.viewControllers.first as! SegmentioViewController
            rulesViewController.selectedSegmentioIndex = 1
            self.present(rulesNavigationController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let orderObject = orderObject, orderObject.count > 0 else { return 0 }
        let count = (expandable == .unExpand) ? 1:orderObject.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_TABLEVIEW_CELL, for: indexPath) as! ProfileTableViewCell
        if let orderObject = orderObject {
            let order = orderObject[indexPath.row]
            print(order)

            let imageURL = "http://app.cario.ir" + order.providerImage
            cell.logoImageView.loadImageUsingCache(withUrl: imageURL)
            // cell.packageImageView.loadImageUsingCache(withUrl: <#T##String#>)
            cell.configureCell(providerName: order.providerName, providerDescription: order.providerDescription, packName: order.productName, price: order.price, slake: order.discount, date: order.date, time: order.timeName)
        }
        return cell
    }
    
}
