//
//  BookingMailViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/11/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import SideMenu

class BookingMailViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    
    @IBAction func menuButtonPressed(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let sideNav = mainStoryboard.instantiateViewController(withIdentifier: RIGHT_SIDE_NAVIGATION_ID) as! UISideMenuNavigationController
        self.present(sideNav, animated: true, completion: nil)
    }
    
    // Method
    func updateUI() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        navigationItem.backBarButtonItem = backButton
        configSideBar()
    }

    func configSideBar() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        SideMenuManager.default.menuRightNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuBlurEffectStyle = .dark
        SideMenuManager.default.menuFadeStatusBar = true
        // SideMenuManager.default.menuWidth = 0.7
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.95
        SideMenuManager.default.menuShadowOpacity = 0.5
        SideMenuManager.default.menuAnimationFadeStrength = 0.05
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BookingNearViewController
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            let indexPath = indexPaths[0]
            let booking = BookingService.instance.bookingCategory[indexPath.row]
            destination.booking = booking
        }
    }
}

extension BookingMailViewController: UISideMenuNavigationControllerDelegate {
    
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

extension BookingMailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return BookingService.instance.bookingCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BOOKING_COLLECTION_CELL, for: indexPath) as! BookingCategoryCollectionViewCell
        let booking = BookingService.instance.bookingCategory[indexPath.row]
        let url = BASE_URL + booking.image
        cell.imageView.loadImageUsingCache(withUrl: url)
        cell.configureCell(name: booking.name)
        cell.centerView.rotate(angle: 45.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        
        return CGSize(width: cellDimention, height: cellDimention * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: BOOKING_TO_PLACE_SEARCH_SEGUE, sender: nil)
    }
    
    
}
