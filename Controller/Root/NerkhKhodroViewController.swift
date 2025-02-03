
//
//  NerkhKhodroViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class NerkhKhodroViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    fileprivate var searchResults = [CarPrice]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        fetchCarPrices()
        searchBarDelegates()
        registerForKeyboardNotifications()
    }
    
    func fetchCarPrices() {
        self.startIndicatorAnimate()
        CarService.instance.fetchCarPrices { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterContent(for searchText: String) {
        searchResults = CarService.instance.carPrices.filter( { (carPrice) -> Bool in
            let brandName = carPrice.brandName
            let modelName = carPrice.modelName
            let isMatch = brandName.localizedCaseInsensitiveContains(searchText) || modelName.localizedCaseInsensitiveContains(searchText)
            return isMatch
        } )
    }

    
    func searchBarDelegates() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        self.definesPresentationContext = true
        SearchBarAppearence()
    }
    
    func SearchBarAppearence() {
        let backButton = UIBarButtonItem(title: "بازگشت", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!], for: .normal)
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.backBarButtonItem = backButton
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setValue("انصراف", forKey:"_cancelButtonText")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "نام خودرو یا برند را جستجو کنید ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!])
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: IRAN_SANS_MOBILE_FONT, size: 15)!], for: .normal)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue =
            info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}

extension NerkhKhodroViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController.isActive) ? searchResults.count : CarService.instance.carPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NERKH_KHODRO_CELL, for: indexPath) as! NerkhKhodroTableViewCell
        let carPrice = (searchController.isActive) ? searchResults[indexPath.row] : CarService.instance.carPrices[indexPath.row]
        cell.configureCell(carName: carPrice.brandName + " | " + carPrice.modelName, detail: carPrice.comments, bazarPrice: carPrice.marketPrice.seperateByCama, namayeshgahPrice: carPrice.agentPrice.seperateByCama, agentChanged: carPrice.agentChange, markerChanged: carPrice.marketChange, date: carPrice.lastUpdate, year: carPrice.year)
        cell.carImageView.loadImageUsingCache(withUrl: "http://app.cario.ir" + carPrice.image)

        return cell
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
