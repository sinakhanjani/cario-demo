//
//  AddCarViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import Dropdowns

class AddCarViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var brands = [Brand]()
    
    fileprivate let defaults = UserDefaults(suiteName: USER_DEFAULT_KEY)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        guard !PresentController.shared.IS_PRESENTED_ADD_CAR_VC else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        let message = "حداقل یک مدل خودرو را انتخاب فرمایید !"
        if let cars = DataManager.shared.cars {
            guard !cars.isEmpty else {
                self.presentWarningAlert(message: message)
                return
            }
            self.defaults.set(true, forKey: PRESENT_ADD_CAR_KEY)
            self.performSegue(withIdentifier: ADD_CAR_TO_LOADER_SEGUE, sender: sender)
        } else {
            self.presentWarningAlert(message: message)
        }
    }
    
    // Method
    func updateUI() {
        if let brands = DataManager.shared.allCarBrands {
            self.brands = brands
        }
    }
    
    static func showModal() -> UINavigationController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: ADD_CAR_VIEW_CONTROLLER_ID) as! UINavigationController
    }
    
   
}

extension AddCarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CAR_SELECT_CELL, for: indexPath) as! CarCollectionViewCell
        let brand = self.brands[indexPath.row]
        let imageURL = "http://app.cario.ir" + brand.logoName
        cell.CarLogoimageView.loadImageUsingCache(withUrl: imageURL)
        cell.configureCell(name: brand.name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = brands[indexPath.row]
        DataManager.shared.carBrand = brand
        presentCarModelViewController()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns: CGFloat = 5
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 5
        }
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 15
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        var height = 1.3 * cellDimention
        if UIScreen.main.bounds.width <= 320 {
            height = 1.4 * cellDimention
        }
        return CGSize(width: cellDimention, height: height)
    }
    
    
}
