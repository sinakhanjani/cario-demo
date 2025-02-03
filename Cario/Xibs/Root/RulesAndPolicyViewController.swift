//
//  RulesAndPolicyViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class RulesAndPolicyViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var serviceLogoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nokatLabel: UILabel!
    @IBOutlet weak var orderListLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var mazayaImageViewTwo: UIImageView!
    @IBOutlet weak var mazayaImageViewOne: UIImageView!
    @IBOutlet weak var mazayaImageViewThree: UIImageView!
    @IBOutlet weak var mazayaLabelOne: UILabel!
    @IBOutlet weak var mazayaLabelTwo: UILabel!
    @IBOutlet weak var mazayaLabelThree: UILabel!
    
    var serviceElement: ServiceElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Action
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        if let serviceElement = serviceElement {
            let serviceId = serviceElement.serviceID
            UserDefaults.standard.setValuesForKeys([serviceId:true])
            if serviceElement.servicesCategoryID == "1" {
                NotificationCenter.default.post(name: SELECTED_CAR_SERVICE_ELEMENT, object: nil)
            } else {
                NotificationCenter.default.post(name: SELECTED_OTHER_CAR_SERVICE_ELEMENT, object: nil)
            }
        }
        removeAnimate()

    }
    
    // Method
    func updateUI() {
        self.showAnimate()
        self.configureTouchXibViewController(bgView: bgView)
        configureElementsUI()
    }
    
    func configureElementsUI() {
        guard let serviceElement = serviceElement else { return }
        guard let notes = serviceElement.notes else { return }
        let bannerImage = notes["service_banner_image"] ?? ""
        let description = notes["text_1"] ?? ""
        let nokatText = notes["nokat_text"] ?? ""
        let khadamatText = notes["khadamat_text"] ?? ""
        let importantText = notes["important_text"] ?? ""
        let mazayaImageOne = notes["mazaya_1_image"] ?? ""
        let mazayaImageTwo = notes["mazaya_2_image"] ?? ""
        let mazayaImageThree = notes["mazaya_3_image"] ?? ""
        let mazayaTextOne = notes["mazaya_1_text"] ?? ""
        let mazayaTextTwo = notes["mazaya_2_text"] ?? ""
        let mazayaTextThree = notes["mazaya_3_text"] ?? ""
        let logoServiceImage = serviceElement.image
        let serviceName = serviceElement.name
        let baseURL = "http://app.cario.ir"
        bannerImageView.loadImageUsingCache(withUrl: baseURL + bannerImage)
        serviceLogoImageView.loadImageUsingCache(withUrl: baseURL + logoServiceImage)
        self.serviceNameLabel.text = serviceName
        self.descriptionLabel.text = description
        self.nokatLabel.text = nokatText
        self.orderListLabel.text = khadamatText
        self.importantLabel.text = importantText
        self.mazayaImageViewOne.loadImageUsingCache(withUrl: baseURL + mazayaImageOne)
        self.mazayaImageViewTwo.loadImageUsingCache(withUrl: baseURL + mazayaImageTwo)
        self.mazayaImageViewThree.loadImageUsingCache(withUrl: baseURL + mazayaImageThree)
        self.mazayaLabelOne.text = mazayaTextOne
        self.mazayaLabelTwo.text = mazayaTextTwo
        self.mazayaLabelThree.text = mazayaTextThree
    }
    
    
}
