//
//  CarModelViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import DropDown

class CarModelViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var carModelButton: RoundedButton!
    @IBOutlet weak var carTeepButton: RoundedButton!
    @IBOutlet weak var carYearButton: RoundedButton!
    
    private let modelButton = DropDown()
    private let teepButton = DropDown()
    private let yearButton = DropDown()
    // Front Data
    fileprivate var modelData: [String] {
        return carBrand.models.map { $0.name }
    }
    fileprivate var teepData = [String]()
    fileprivate var yearData = Date().loadHundredYear()
    // backend Data
    fileprivate var carBrand: Brand!
    fileprivate var carModel: Model?
    fileprivate var carTeep: Teep?
    fileprivate var year: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureDropDownButtons()
    }
    
    // Objc
    @objc func closeTouch() {
        removeAnimation()
    }
    
    // Actions
    @IBAction func carModelButtonPressed(_ sender: RoundedButton) {
        modelButton.show()
    }
    
    @IBAction func carTeepButtonPressed(_ sender: RoundedButton) {
        teepButton.show()
    }
    
    @IBAction func carYearButtonPressed(_ sender: RoundedButton) {
        yearButton.show()
    }
    
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        guard let carModel = carModel, let carTeep = carTeep, let year = year else {
            let message = "لطفا تمامی اطلاعات را انتخاب نمایید"
            self.presentWarningAlert(message: message)
            return
        }
        self.startIndicatorAnimate()
        CarService.instance.userCarRequest(teepId: carTeep.id, modelId: carModel.id, year: year) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    let car_Brand = CarBrand(id: self.carBrand.id, name: self.carBrand.name, latinName: self.carBrand.latinName, slug: self.carBrand.slug, isActive: "1", logoName: self.carBrand.logoName, isProductionYear: self.carBrand.isProductionYear, iran: self.carBrand.iran)
                    let car_Model = CarModel(id: carModel.id, brandId: carModel.brandId, name: carModel.name, latinName: carModel.latinName, slug: carModel.slug, isActive: "1", size: carModel.size)
                    let car_teep = CarTeep(id: carTeep.id, modelId: carTeep.modelId, name: carTeep.name, latinName: carTeep.latinName, slug: carTeep.slug, motorOilCapacity: carTeep.motorOilCapacity, motorOilCapacityNoFilterChange: carTeep.motorOilCapacityNoFilterChange, wageRatio: carTeep.wageRatio, isActive: "1")
                    let car = Car(id: "1", carModelId: carModel.id, carTeepId: carTeep.id, userId: Authentication.auth.userId, isActive: "1", date: "1397", year: year, carBrand: car_Brand, carModel: car_Model, carTeep: car_teep)
                    if let _ = DataManager.shared.cars {
                        DataManager.shared.cars?.append(car)
                    } else {
                        DataManager.shared.cars = [car]
                    }
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.removeAnimation()
                    }
                }
            })
        }
    }

    // Method
    func updateUI() {
        self.bgView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.bgView.alpha = 0.0
        UIView.animate(withDuration: 1.0) {
            self.bgView.alpha = 1.0
            self.bgView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        self.menuView.transform = CGAffineTransform(translationX: 0, y: 1000)
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.menuView.alpha = 1.0
            self.menuView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        let touch = UITapGestureRecognizer(target: self, action: #selector(closeTouch))
        bgView.addGestureRecognizer(touch)
        self.carBrand = DataManager.shared.carBrand
    }
    
    func configureDropDownButtons() {
        modelButton.anchorView = carModelButton
        modelButton.bottomOffset = CGPoint(x: 100, y: carModelButton.bounds.height)
        teepButton.anchorView = carTeepButton
        teepButton.bottomOffset = CGPoint(x: 0, y: carTeepButton.bounds.height)
        yearButton.anchorView = carYearButton
        yearButton.bottomOffset = CGPoint(x: 0, y: carYearButton.bounds.height)
        modelButton.textFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!
        teepButton.textFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!
        yearButton.textFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!
        modelButton.dataSource = modelData
        teepButton.dataSource = teepData
        yearButton.dataSource = yearData
        // Actions for buttons
        self.modelButton.selectionAction = { [weak self] (index, item) in
            self?.carModelButton.setTitle(self?.modelData[index], for: .normal)
            let model = self?.carBrand.models[index]
            self?.carModel = model
            if let teeps = model?.teeps {
                let data = teeps.map { $0.name }
                self?.teepButton.dataSource = data
                if !data.isEmpty {
                    self?.carTeepButton.setTitle(data[0], for: .normal)
                    self?.carTeep = teeps[0]
                } else {
                    self?.carTeep = Teep(id: "-1", modelId: model!.id, name: "", latinName: "", slug: "", motorOilCapacity: "", motorOilCapacityNoFilterChange: "", wageRatio: "", isActive: "1")
                }
            }
        }
        self.teepButton.selectionAction = { [weak self] (index, item) in
            self?.carTeep = self?.carModel?.teeps[index]
            self?.carTeepButton.setTitle(self?.carTeep?.name, for: .normal)
        }
        self.yearButton.selectionAction = { [weak self] (index, item) in
            self?.carYearButton.setTitle(self?.yearData[index], for: .normal)
            self?.year = self?.yearData[index]
        }
    }

    func removeAnimation() {
        UIView.animate(withDuration: 1.0, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: .allowUserInteraction, animations: {
            self.menuView.transform = CGAffineTransform.init(translationX: 0, y: 1000)
            self.menuView.alpha = 0.9
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
    
    
}


