//
//  UIViewControllerExtension.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import SideMenu
import CDAlertView
import Lottie
import SwiftSVG

extension UIViewController {
    
    func webServiceAlert(withType type: Alert, escape: @escaping COMPLETION_HANDLER) {
        DispatchQueue.main.async {
            switch type {
            case .none:
                self.stopIndicatorAnimate()
                print("Alert Type: none")
                break
            case .success:
                print("Alert Type: success")
                escape(.success)
            case .failed:
                self.stopIndicatorAnimate()
                print("Alert Type: failed")
                let message = " !خطا در برقرارای ارتباط با سرور"
                self.presentWarningAlert(message: message)
            case .server:
                self.stopIndicatorAnimate()
                print("Alert Type: server")
                let message = "اطلاعات از سرور کاریو دریافت نشد !"
                self.presentWarningAlert(message: message)
            case .network:
                self.stopIndicatorAnimate()
                print("Alert Type: network")
                let message = "ارتباط شما با اینترنت قطغ میباشد !"
                self.presentWarningAlert(message: message)
            case .invalidInput:
                self.stopIndicatorAnimate()
                print("Alert Type: invalid Input textField")
                let message = "لطفا اطلاعات ورودی را بررسی نمایید"
                self.presentWarningAlert(message: message)
            case .duplicate:
                self.stopIndicatorAnimate()
                print("Alert Type: duplicate in server")
                let message = "با این شماره قبلا ثبت نام کرده اید، لطفا گزینه ورود را انتخاب کنید !"
                self.presentWarningAlert(message: message)
            case .json:
                self.stopIndicatorAnimate()
                print("Alert Type: json")
            case .data:
                self.stopIndicatorAnimate()
                print("Alert Type: data")
            case .noLogin:
                self.stopIndicatorAnimate()
                print("Alert Type: noLogin")
                let message = "این شماره قبلا در سیستم ثبت است، لطفا مجددا تلاش کنید !"
                self.presentWarningAlert(message: message)
            case .wrongCode:
                self.stopIndicatorAnimate()
                print("Alert Type: wringCode")
                let message = "کد تایید را اشتباه وارد کرده اید !"
                self.presentWarningAlert(message: message)
            case .INVALID_MAX_USAGE_DISCOUNT:
                self.stopIndicatorAnimate()
                print("Alert Type: INVALID_MAX_USAGE_DISCOUNT")
                let message = "کاربر گرامی بیش از حد از کوپن تخفیف استفاده شده است !"
                self.presentWarningAlert(message: message)
            case .NVALID_MAX_DISTANCE_DISCOUNT:
                self.stopIndicatorAnimate()
                print("Alert Type: NVALID_MAX_DISTANCE_DISCOUNT")
                let message = "کاربر گرامی فاصله مکانی شما بیشتر از حد مجاز میباشد !"
                self.presentWarningAlert(message: message)
            case .SYSTEM_ERROR:
                self.stopIndicatorAnimate()
                print("Alert Type: SYSTEM_ERROR")
                let message = "بروز خطای سیستمی، لطفا دقایقی دیگر مجددا تلاش کنید !"
                self.presentWarningAlert(message: message)
            case .SUCCESSFULL_ORDER:
                print("Alert Type: SUCCESSFULL_ORDER")
                escape(.success)
            case .FAILED_ORDER:
                self.stopIndicatorAnimate()
                print("Alert Type: FAILED_ORDER")
                let message = "لطفا سفارش خود را مجددا ثبت کنید، ثبت سفارش با مشکل مواجه شده است !"
                self.presentWarningAlert(message: message)
            case .VALID_DISCOUNT:
                self.stopIndicatorAnimate()
                print("Alert Type: VALID_DISCOUNT")
                escape(.success)
                let message = "کوپن تخفیف با موفقیت لحاظ شد !"
                self.presentWarningAlert(message: message)
            case .INVALID_DISCOUNT:
                self.stopIndicatorAnimate()
                print("Alert Type: INVALID_DISCOUNT")
                let message = "کوپن تخفیف مجاز نمی باشد !"
                self.presentWarningAlert(message: message)
            case .donePay:
                self.stopIndicatorAnimate()
                print("Alert Type: donePay")
                escape(.success)
            case .notEnoughtToPay:
                self.stopIndicatorAnimate()
                print("Alert Type: notEnoughtToPay")
                let message = "مبلغ موجودی حساب شما کافی نمی باشد !"
                self.presentWarningAlert(message: message)
            }
        }
    }
    
    
}

extension UIViewController {
    
    func configureSideBar() {
        // Define the menus
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        //Set up a cool background image for demo purposes
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuBlurEffectStyle = .dark
        SideMenuManager.default.menuFadeStatusBar = true
        // SideMenuManager.default.menuWidth = 0.7
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.95
        SideMenuManager.default.menuShadowOpacity = 0.5
        SideMenuManager.default.menuAnimationFadeStrength = 0.05
    }
    
}

extension UIViewController {
    
    // ViewControllers
    func dismissesKeyboardByTouch() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(touchPressed))
        self.view.addGestureRecognizer(touch)
    }
    
    @objc func touchPressed() {
        self.view.endEditing(true)
    }
    
    // Xibs ViewController
    func configureTouchXibViewController(bgView: UIView) {
        let touch = UITapGestureRecognizer(target: self, action: #selector(dismissTouchPressed))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc func dismissTouchPressed() {
        removeAnimate()
    }
    
}

extension UIViewController {
    
    func presentWarningAlert(message: String) {
        let alert = CDAlertView(title: "توجه", message: message, type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 15)!
        alert.messageFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 13)!
        let cancel = CDAlertViewAction(title: "باشه", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white, handler: nil)
        alert.add(action: cancel)
        alert.show()
    }
    
    func phoneNumberCondition(phoneNumber number: String) -> Bool {
        guard !number.isEmpty else {
            let message = "شماره همراه خالی میباشد !"
            presentWarningAlert(message: message)
            return false
        }
        let startIndex = number.startIndex
        let zero = number[startIndex]
        guard zero == "0" else {
            let message = "شماره همراه خود را با صفر وارد کنید !"
            presentWarningAlert(message: message)
            return false
        }
        guard number.count == 11 else {
            let message = "شماره همراه میبایست یازده رقمی باشد !"
            presentWarningAlert(message: message)
            return false
        }
        
        return true
    }
    
}

extension UIViewController {
    
    func showAnimate() {
        self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
}

extension UIViewController {
    
    func startIndicatorAnimate() {
        let indicatorVC = IndicatorViewController()
        self.addChild(indicatorVC)
        indicatorVC.view.frame = self.view.frame
        self.view.addSubview(indicatorVC.view)
        indicatorVC.didMove(toParent: self)
    }
    
    func stopIndicatorAnimate() {
        NotificationCenter.default.post(name: DISMISS_INDICATOR_VC_NOTIFY, object: nil)
    }
    
}

extension UIViewController {
    
    func loadLottieJson(bundleName name: String, lottieView: UIView) {
        // Create Boat Animation
        let boatAnimation = LOTAnimationView(name: name)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopAnimation = true
        boatAnimation.play()
    }
    
    func loadLottieFromURL(url: URL?, lottieView: UIView) {
        // Create Boat Animation
        guard let url = url else { return }
        let boatAnimation = LOTAnimationView.init(contentsOf: url)
        // Set view to full screen, aspectFill
        boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation.contentMode = .scaleAspectFill
        boatAnimation.frame = lottieView.bounds
        // Add the Animation
        lottieView.addSubview(boatAnimation)
        boatAnimation.loopAnimation = true
        boatAnimation.play()
    }
    
}

// Xibs Present Controller
extension UIViewController {
    
    func presentCarModelViewController() {
        let carModelViewController = CarModelViewController()
        self.addChild(carModelViewController)
        carModelViewController.view.frame = self.view.frame
        self.view.addSubview(carModelViewController.view)
        carModelViewController.didMove(toParent: self)
    }
    
    func presentChargeViewController() {
        let chargeViewController = ChargeViewController()
        self.addChild(chargeViewController)
        chargeViewController.view.frame = self.view.frame
        self.view.addSubview(chargeViewController.view)
        chargeViewController.didMove(toParent: self)
    }
    
    func presentRateViewController(rateDetail:(orderId: String, condition: String)) {
        let rateViewController = RateViewController()
        rateViewController.rateDetail = rateDetail
        self.addChild(rateViewController)
        rateViewController.view.frame = self.view.frame
        self.view.addSubview(rateViewController.view)
        rateViewController.didMove(toParent: self)
    }

    func presentWarningViewController() {
        let warningViewController = WarningViewController()
        self.addChild(warningViewController)
        warningViewController.view.frame = self.view.frame
        self.view.addSubview(warningViewController.view)
        warningViewController.didMove(toParent: self)
    }
    
    func presentVersionViewController() {
        let versionViewController = VersionViewController()
        self.addChild(versionViewController)
        versionViewController.view.frame = self.view.frame
        self.view.addSubview(versionViewController.view)
        versionViewController.didMove(toParent: self)
    }
    
    func presentFirstOrderViewController() {
        let firstOrderViewController = FirstOrderViewController()
        self.addChild(firstOrderViewController)
        firstOrderViewController.view.frame = self.view.frame
        self.view.addSubview(firstOrderViewController.view)
        firstOrderViewController.didMove(toParent: self)
    }
    
    func presentMessageViewController() {
        let messageViewController = MessageViewController()
        self.addChild(messageViewController)
        messageViewController.view.frame = self.view.frame
        self.view.addSubview(messageViewController.view)
        messageViewController.didMove(toParent: self)
    }
    
    func presentGeoViewController(serviceID: String, providerID: String) {
        let geoShowerViewController = GeoShowerViewController()
        geoShowerViewController.providerID = providerID
        geoShowerViewController.serviceID = serviceID
        self.addChild(geoShowerViewController)
        geoShowerViewController.view.frame = self.view.frame
        self.view.addSubview(geoShowerViewController.view)
        geoShowerViewController.didMove(toParent: self)
    }
    
    func presentRulesAndPolicyViewController(serviceElement: ServiceElement?) {
        let rulesAndPolicyViewController = RulesAndPolicyViewController()
        rulesAndPolicyViewController.serviceElement = serviceElement
        self.addChild(rulesAndPolicyViewController)
        rulesAndPolicyViewController.view.frame = self.view.frame
        self.view.addSubview(rulesAndPolicyViewController.view)
        rulesAndPolicyViewController.didMove(toParent: self)
    }

    func presentPaymentViewController(orderId: String) {
        let paymentViewController = PaymentViewController()
        paymentViewController.orderId = orderId
        self.addChild(paymentViewController)
        paymentViewController.view.frame = self.view.frame
        self.view.addSubview(paymentViewController.view)
        paymentViewController.didMove(toParent: self)
    }
    
}

// cashed imageView
let brandImageCash = NSCache<NSString, AnyObject>()
extension UIViewController {

    func svgURL(svgView: UIView, url: URL, color: UIColor?) {
        // check cached view
        if let cachedImage = brandImageCash.object(forKey: url.path as NSString) as? UIView {
            svgView.addSubview(cachedImage)
            return
        }
        let hammock = UIView(SVGURL: url) { (svgLayer) in
            if let color = color {
                svgLayer.fillColor = color.cgColor
            } else {
                svgLayer.fillColor = nil
            }
            svgLayer.resizeToFit(svgView.bounds)
        }
        brandImageCash.setObject(hammock, forKey: url.path as NSString)
        svgView.addSubview(hammock)
    }
    
    
}

extension UIViewController {
    
    func loadViewControllerByServer(identifier: String, target: String, sender: Any?) {
        switch identifier {
        case "banner":
            if let url = URL.init(string: target) {
                WebService.instance.openURL(url: url)
            } else {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let present = storyBoard.instantiateViewController(withIdentifier: target)
                self.present(present, animated: true, completion: nil)
            }
        default:
            self.performSegue(withIdentifier: identifier, sender: sender)
            break
        }
    }
    
    
}
