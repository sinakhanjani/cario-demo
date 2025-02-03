
//
//  LoaderViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    
    var tipNumber: Int {
        get {
            return UserDefaults.standard.integer(forKey: TIP_KEY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TIP_KEY)
        }
    }
    
    fileprivate let dispathGroup = DispatchGroup()
    private let popTransitionAnimator = PopTransitionAnimator()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // First ViewController Presentation
        guard WebService.instance.isConnectedToNetwork() else { // check internet connection
            self.webServiceAlert(withType: .network) { (_) in
                //
            }
            return
        }
        guard PresentController.shared.IS_PRESENTED_WALK_TROUGHT_VC else {
            self.present(CarioPageViewController.showModal(), animated: true, completion: nil)
            return
        }
        guard PresentController.shared.IS_PRESENTED_REGISTERATION_VC else {
            self.present(RegistrerationViewController.showModal(), animated: true, completion: nil)
            return
        }
        guard PresentController.shared.IS_PRESENTED_ADD_CAR_VC else {
            self.present(AddCarViewController.showModal(), animated: true, completion: nil)
            return
        }
        // Otther first load request here
        self.loadCarioInitRequest()
        self.loadBrandsRequest()
        self.loadProfileContentRequest()
        self.loadBookingCategoryRequest()
        dispathGroup.notify(queue: .main) {
            print("Complete fetch all data from cario server, Ready to Go!")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.performSegue(withIdentifier: LOADER_TO_MAIN_SEGUE, sender: nil)
            }
        }
    }
    
    // OBjc
    @objc func checkVersionApplication() {
        dispathGroup.leave()
    }
    
    // Action
    @IBAction func unwindToLoaderVC(_ seugue: UIStoryboardSegue) {
        //
    }
    
    // Method
    func updateUI() {
        self.loadLottieJson(bundleName: "lootie_splash", lottieView: logoView)
        NotificationCenter.default.addObserver(self, selector: #selector(checkVersionApplication), name: REMOVE_VERSION_VC, object: nil)
    }
    
    func loadBrandsRequest() {
        dispathGroup.enter()
        CarService.instance.getAllCarRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    self.dispathGroup.leave()
                }
            })
        }
        /*
        if let brands = DataManager.shared.allCarBrands {
            for brand in brands {
                dispathGroup.enter()
                let imageURL = URL(string: "http://app.cario.ir" + brand.logoName)!
                let cashView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                self.svgURL(svgView: cashView, url: imageURL, color: .white)
                self.dispathGroup.leave()
            }
        }
         */
    }
    
    func loadProfileContentRequest() {
        dispathGroup.enter()
        LoginService.instance.profileUpRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    self.dispathGroup.leave()
                }
            })
        }
    }
    
    func loadCarioInitRequest() {
        dispathGroup.enter()
        LoginService.instance.fetchInitRequest(tip: "1") { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    if let carioInit = LoginService.instance.carioInit {
                        // Carop Tips text ...
                        if !carioInit.tips.isEmpty {
                            DispatchQueue.main.async {
                                self.tipLabel.text = carioInit.tips[self.tipNumber].tip_meesage
                            }
                            if (carioInit.tips.count - 1) > self.tipNumber {
                                self.tipNumber += 1
                            }
                        }
                        // Cario App Version ...
                        if carioInit.version.minVersion > Int(VERSION)! || Int(VERSION)! < carioInit.version.version {
                            DispatchQueue.main.async {
                                self.presentVersionViewController()
                            }
                        } else {
                            self.dispathGroup.leave()
                        }
                        if !DataManager.shared.firstTimeRulesAndPolicy {
                            for service in carioInit.services {
                                for serviceElement in service.service {
                                    if let notes = serviceElement.notes {
                                        if let serviceId = notes["service_id"] {
                                            UserDefaults.standard.setValuesForKeys([serviceId:false])
                                        }
                                    }
                                }
                            }
                            DataManager.shared.firstTimeRulesAndPolicy = true
                        }
                    }
                }
            })
        }
    }
    
    func loadBookingCategoryRequest() {
        dispathGroup.enter()
        BookingService.instance.getAllCategoriesRequest { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    self.dispathGroup.leave()
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination
        toViewController.transitioningDelegate = popTransitionAnimator
    }
    
    
    
}
