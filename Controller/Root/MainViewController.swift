//
//  MenuViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import SideMenu
import Berry

class MainViewController: UIViewController,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var otherServiceCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var otherServiceCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    let carServiceCollectionView = CarServiceCollectionView()
    let otherCarServiceCollectionView = OtherCarServiceCollectionView()
    
    fileprivate var dropData: [BerryMenuItem] {
        var berryItems = [BerryMenuItem]()
        if let cars = DataManager.shared.cars {
            guard !cars.isEmpty else {
                let berryMenuItem = BerryMenuItem.init("", icon: "", iconHighlight: "")
                berryItems.append(berryMenuItem)
                return berryItems
            }
            for car in cars {
                if let carModel = car.carModel {
                    if let carBrand = car.carBrand {
                        let item = BerryMenuItem("\(carBrand.name) | \(carModel.name)", icon: "", iconHighlight: "")
                        berryItems.append(item)
                    }
                }
            }
        }
        return berryItems
    }
    fileprivate var selectedStageIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: SELECTED_CAR_INDEX_KEY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SELECTED_CAR_INDEX_KEY)
        }
    }
    fileprivate var berryView: BerryView!
    
    var serviceElement: ServiceElement!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.configureSideBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupNavigationItem()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        berryView.dismiss()
    }
    
    // Objc
    @objc func selectedCarService() {
        if let serviceElement = carServiceCollectionView.serviceElement {
            self.serviceElement = serviceElement
            if mustBePresentRulesAndPolicy(serviceId: serviceElement.serviceID) {
                self.presentRulesAndPolicyViewController(serviceElement: serviceElement)
            } else {
                self.performSegue(withIdentifier: GOOGLE_COORDINATE_VC_ID, sender: nil)
            }
        } else {
            self.performSegue(withIdentifier: SUGGESTION_VIEW_CONTROLLER_SEGUE, sender: nil)
        }
    }
    
    @objc func selectedOtherCarService() {
        if let serviceElement = otherCarServiceCollectionView.serviceElement {
            if mustBePresentRulesAndPolicy(serviceId: serviceElement.serviceID) {
                self.presentRulesAndPolicyViewController(serviceElement: serviceElement)
            } else {
                self.loadViewControllerByServer(identifier: serviceElement.serviceType, target: serviceElement.target, sender: nil)
            }
        } else {
            self.performSegue(withIdentifier: SUGGESTION_VIEW_CONTROLLER_SEGUE, sender: nil)
        }
    }
    
    // Actions
    @IBAction func unwindToMainVC(_ segue: UIStoryboardSegue) {
        //
    }
    
    @IBAction func addCarButtonPressed(_ sender: UIBarButtonItem) {
        berryView.dismiss()
        self.present(AddCarViewController.showModal(), animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.isPresentFirstOrderViewController()
            self.isPresentMessageViewController()
        }
        serviceCollectionView.dataSource = carServiceCollectionView
        serviceCollectionView.delegate = carServiceCollectionView
        otherServiceCollectionView.delegate = otherCarServiceCollectionView
        otherServiceCollectionView.dataSource = otherCarServiceCollectionView
        configureConstraintsCollection()
        NotificationCenter.default.addObserver(self, selector: #selector(selectedOtherCarService), name: SELECTED_OTHER_CAR_SERVICE_ELEMENT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectedCarService), name: SELECTED_CAR_SERVICE_ELEMENT, object: nil)
    }
    
    func isPresentFirstOrderViewController() {
        if let carioInit = LoginService.instance.carioInit {
            if carioInit.firstOrder.firstOrder == 1 {
                self.presentFirstOrderViewController()
            }
        }
    }
    
    func isPresentMessageViewController() {
        guard let carioInit = LoginService.instance.carioInit else { return }
        if let messageSingle = carioInit.messageSingle {
            if messageSingle.id != String(DataManager.shared.messageId) {
                DataManager.shared.messageId = Int(messageSingle.id)!
                self.presentMessageViewController()
            }
        }
    }
    
    func configureConstraintsCollection() {
        let serviceCollectionHeight:CGFloat = serviceCollectionView.collectionViewLayout.collectionViewContentSize.height
        let otherServiceCollectionHeight:CGFloat = otherServiceCollectionView.collectionViewLayout.collectionViewContentSize.height
        self.serviceCollectionHeight.constant = serviceCollectionHeight
        self.otherServiceCollectionHeight.constant = otherServiceCollectionHeight
        scrollViewHeight.constant = serviceCollectionHeight + otherServiceCollectionHeight + 120
        if UIScreen.main.bounds.width > 320 {
            self.serviceCollectionHeight.constant = serviceCollectionHeight - 100
            self.otherServiceCollectionHeight.constant = otherServiceCollectionHeight - 100
        }
        scrollViewHeight.constant = self.serviceCollectionHeight.constant + self.otherServiceCollectionHeight.constant + 120
        self.automaticallyAdjustsScrollViewInsets = false
        serviceCollectionView.collectionViewLayout.invalidateLayout()
        otherServiceCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupNavigationItem() {
        let config = BerryConfig.default()
        config.arrowProperty.arrowImage = "arrow"
        config.cellProperty.cellBackgroundColor = #colorLiteral(red: 0.1756279171, green: 0.2602387667, blue: 0.3320356607, alpha: 1)
        config.cellProperty.cellHeight = 50.0
        config.cellProperty.cellTextLabelFont = UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!
        config.cellProperty.cellTextLabelColor = .white
        config.cellProperty.cellSelectedBackgroundColor = #colorLiteral(red: 0.1286308467, green: 0.1932508349, blue: 0.2481646836, alpha: 1)
        config.cellProperty.cellSelectedTextLabelColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        config.cellProperty.hideHorizontalSeparator = true
        config.menuProperty.menuMaxShowingRows = dropData.count
        config.menuProperty.menuTitleFont = UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 15)!
        config.menuProperty.menuBackgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        config.menuProperty.menuTitleColor = .white
        config.menuProperty.tapBackgroundHideMenu = true
        let berry = BerryView(navigationController: navigationController, containerView: view, selectedIndex: [selectedStageIndex], items: dropData, config: config)
        berry.didSelectedRowsAtIndexPath = { indexPath in
            let selectedIndex = indexPath.row
            self.selectedStageIndex = selectedIndex
        }
        berryView = berry
        navigationItem.titleView = berry
    }
    
    func mustBePresentRulesAndPolicy(serviceId: String) -> Bool {
        if let condition = UserDefaults.standard.value(forKey: serviceId) as? Bool {
            switch condition {
            case true:
                return false
            case false:
                return true
            }
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case DynamticSegue.khalafi.rawValue:
            let destination = segue.destination as! UINavigationController
            let khalafiViewController = destination.viewControllers.first as! KhalafiViewController
            khalafiViewController.titleHeader = otherCarServiceCollectionView.serviceElement!.name
        case DynamticSegue.nomreManfi.rawValue:
            let destination = segue.destination as! UINavigationController
            let nomrehManfiViewController = destination.viewControllers.first as! NomrehManfiViewController
            nomrehManfiViewController.titleHeader = otherCarServiceCollectionView.serviceElement!.name
        case DynamticSegue.emdadKhodro.rawValue:
            let destination = segue.destination as! UINavigationController
            let emdadKhodroViewController = destination.viewControllers.first as! EmdadKhodroViewController
            emdadKhodroViewController.titleHeader = otherCarServiceCollectionView.serviceElement!.name
        case SUGGESTION_VIEW_CONTROLLER_SEGUE:
                break
        case GOOGLE_COORDINATE_VC_ID:
            let destination = segue.destination as! UINavigationController
            let googleViewController = destination.viewControllers.first as! GoogleViewController
            googleViewController.serviceElement = serviceElement
            break
        default:
            break
        }
    }
    
}

extension MainViewController: UISideMenuNavigationControllerDelegate {
    
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


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OTHER_CAR_SERVICE_COLLECTION_VIEW_CELL, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 0
        let cellDimention = ((UIScreen.main.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        
        return CGSize(width: cellDimention, height: cellDimention * 1.2)
    }
    
    
}
