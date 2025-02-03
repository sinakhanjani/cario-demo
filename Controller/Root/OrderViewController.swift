//
//  OrderViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import DropDown
import CDAlertView

class OrderViewController: UIViewController, UITextViewDelegate {

    // UpSection
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    // DownSection
    @IBOutlet weak var suggestionTextView: UITextView!
    @IBOutlet weak var dateButton: RoundedButton!
    @IBOutlet weak var timeButton: RoundedButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tomanLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var moreDetailTextView: UITextView!
    @IBOutlet weak var discountButton: RoundedButton!
    
    private let dateDropButton = DropDown()
    private let timeDropButton = DropDown()
    private var dateAndTime: (date: String?, time: String?)?
    
    enum CellState {
        case expanded
        case collapsed
    }
    
    private var cellStates: [CellState]?
    private var selectedPlatformOrder: PlatformOrder?
    var userSelectedLocation: CLLocationCoordinate2D?
    var provider: Provider?
    var totalPrice: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Objc
    @objc func dismissKeyboardWithTableView() {
        self.view.endEditing(true)
    }
    
    @objc func uwindToRootViewController() {
        let alert = CDAlertView(title: "با تشکر از انتخاب شما", message: "سفارش شما با موفقیت ثبت شد، به زودی با شما تماس خواهیم گرفت !", type: CDAlertViewType.notification)
        alert.titleFont = UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!
        alert.messageFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 14)!
        let done = CDAlertViewAction(title: "باشه", font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 13)!, textColor: UIColor.darkGray, backgroundColor: .white) { (action) -> Bool in
            self.performSegue(withIdentifier: ORDER_VC_TO_MAIN_VC_SEGUE, sender: nil)
            return true
        }
        alert.add(action: done)
        alert.show()
    }

    
    // Action
    @IBAction func dateButtonPressed(_ sender: RoundedButton) {
        dateDropButton.show()
    }
    
    @IBAction func timeButtonPressed(_ sender: RoundedButton) {
        timeDropButton.show()
    }
    
    @IBAction func discountAgreeButtonPressed(_ sender: RoundedButton) {
        guard let userSelectedLocation = userSelectedLocation else {
            let message = "مکان شما ثبت نشده است !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let provider = provider else { return }
        guard let discount = discountTextField.text, discountTextField.text != "" else {
            let message = "لطفا کوپن تخفیف را وارد نمایید !"
            self.presentWarningAlert(message: message)
            return
        }
        self.startIndicatorAnimate()
        OrderService.instance.checkDiscount(lat: "\(userSelectedLocation.latitude)", long: "\(userSelectedLocation.longitude)", providerId: provider.providerID, serviceId: provider.serviceID, discount: discount) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.discountLabel.text = "گوپن تخفیف شما لحاظ شد و از مبلغ کل کسر شد !"
                        if let coponPrice = OrderService.instance.discountCopon {
                            if let totalPrice = self.totalPrice {
                                self.totalPrice = totalPrice - self.discountPrice(discount: coponPrice, price: totalPrice)
                                self.totalPriceLabel.text = self.totalPrice!.seperateByCama
                            }
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func agreeButtonPressed(_ sender: RoundedButton) {
        guard let userSelectedLocation = userSelectedLocation else {
            let message = "مکان شما ثبت نشده است !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let provider = provider else { return }
        guard let platformOrder = selectedPlatformOrder else {
            let message = "سرویس مورد نظر را انتخاب نمایید !"
            self.presentWarningAlert(message: message)
            return
        }
        guard let dateAndTime = dateAndTime else {
            let message = "لطفا زمان و تاریخ سرویس را انتخاب نمایید"
            self.presentWarningAlert(message: message)
            return
        }
        guard let time = dateAndTime.time else {
            let message = "لطفا زمان را انتخاب نمایید"
            self.presentWarningAlert(message: message)
            return
        }
        guard let date = dateAndTime.date else {
            let message = "لطفا تاریخ را انتخاب نمایید"
            self.presentWarningAlert(message: message)
            return
        }
        self.startIndicatorAnimate()
        let amount = String(platformOrder.product_price ?? 0)
        let comment = moreDetailTextView.text ?? ""
        let discount = OrderService.instance.discountCopon ?? ""
        let discountCode = OrderService.instance.discountCode ?? ""
        let finalAmount = String(self.totalPrice ?? 0)
        OrderService.instance.submitOrder(address: "", amount: amount, comment: comment, date: date, time: time, discount: discount, discountCode: discountCode, finalAmount: finalAmount, lat: "\(userSelectedLocation.latitude)", long: "\(userSelectedLocation.longitude)", productId: platformOrder.product_id, serviceId: provider.serviceID, providerId: provider.providerID, userCarId: DataManager.shared.selectedCar!.id) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.moreDetailTextView.text = ""
                        if let orderPlatform = self.selectedPlatformOrder {
                            if orderPlatform.fixed_pricing == "0" {
                                NotificationCenter.default.post(name: CHECK_COMPLETE_ORDER_SUBMIT, object: nil)
                            } else {
                                guard let orderId = OrderService.instance.orderCode else { return }
                                self.presentPaymentViewController(orderId: orderId)
                            }
                        }
                    }
                }
            })
        }
    }
    
    // Method
    func updateUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(uwindToRootViewController), name: CHECK_COMPLETE_ORDER_SUBMIT, object: nil)
        if let provider = provider {
            self.title = provider.name
            self.serviceImageView.loadImageUsingCache(withUrl: "http://app.cario.ir" + provider.image)
            self.fetchPlatformOrder(provider: provider)
        }
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        self.view.bindToKeyboard()
        let touch = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboardWithTableView))
        touch.cancelsTouchesInView = false
        self.view.addGestureRecognizer(touch)
        suggestionTextView.delegate = self
        suggestionTextView.font = UIFont.iranSansFont(size: 13)
        self.discountTextField.keyboardType = .asciiCapableNumberPad
    }
    
    func configureDropDownButtons() {
        dateDropButton.anchorView = dateButton
        dateDropButton.bottomOffset = CGPoint(x: 0, y: dateButton.bounds.height)
        timeDropButton.anchorView = timeButton
        timeDropButton.bottomOffset = CGPoint(x: 0, y: dateButton.bounds.height)
        dateDropButton.textFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!
        timeDropButton.textFont = UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!
        dateDropButton.dataSource = [String]()
        timeDropButton.dataSource = [String]()
        if let provider = provider {
            timeDropButton.dataSource = Date().openTime(provider: provider, catId: "1", splitHour: provider.splitHour)
            dateDropButton.dataSource = Date().openDate(maxDay: provider.nextDaysOrder)
        }
        self.dateDropButton.selectionAction = { [weak self] (index, item) in
            if let provider = self?.provider {
                let dates = Date().openDate(maxDay: provider.nextDaysOrder)
                guard !dates.isEmpty else { return }
                let date = dates[index]
                self?.dateAndTime = (date: date, time: self?.dateAndTime?.time)
                self?.dateButton.setTitle(date, for: .normal)
                self?.configureTimeForOrder(provider: provider)
            }
        }
        self.timeDropButton.selectionAction = { [weak self] (index, item) in
            if let provider = self?.provider {
                let dates = Date().openDate(maxDay: provider.nextDaysOrder)
                guard !dates.isEmpty else {
                    let message = "لطفا ابتدا تاریخ را معین کنید"
                    self?.presentWarningAlert(message: message)
                    return
                }
                guard !self!.timeDropButton.dataSource.isEmpty else { return }
                let time = self?.timeDropButton.dataSource[index]
                self?.timeButton.setTitle(time, for: .normal)
                self?.dateAndTime = (date: self?.dateAndTime?.date, time: time)
            }
        }
    }
    
    func configureTimeForOrder(provider: Provider) {
        if let date =  self.dateAndTime?.date {
            var times = [String]()
            if date == Date().PersianDate() {
                times = Date().openTime(provider: provider, catId: "1", splitHour: provider.splitHour)
            } else {
                times = Date().openTimeWeek(provider: provider, catId: "1", splitHour: provider.splitHour)
            }
            timeDropButton.dataSource = times
        }
    }
    
    func fetchPlatformOrder(provider: Provider) {
        self.startIndicatorAnimate()
        OrderService.instance.fetchPlatformOrder(serviceId: provider.serviceID, providerId: provider.providerID, userCarId: DataManager.shared.selectedCar!.id) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.setDefaultPlatformOrder()
                        self.tableView.reloadData()
                        self.configureOrderUI()
                        self.configureDropDownButtons()
                        self.stopIndicatorAnimate()
                    }
                }
            })
        }
    }

    func setDefaultPlatformOrder() {
        let platformOrders = OrderService.instance.platformOrders
        guard !platformOrders.isEmpty else { return }
        self.cellStates = [CellState](repeating: .collapsed, count: platformOrders.count)
        for platform in platformOrders {
            if platform.enabled == "1" {
                self.selectedPlatformOrder = platform
            }
            return
        }
    }
    
    func discountPrice(discount: String, price: Int) -> Int {
        let disCount = Int(discount)!
        if disCount <= 100 {
            let finalPrice = (disCount * price) / 100
            return finalPrice
        }
        return Int(discount)!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        suggestionTextView.text = ""
    }
    
    func configureOrderUI() {
        if let selectedPlatformOrder = self.selectedPlatformOrder {
            // PriceLabel
            let price = selectedPlatformOrder.product_price ?? 0
            self.totalPrice = price
            let discount = discountPrice(discount: selectedPlatformOrder.discount, price: price)
            let wage = Int(selectedPlatformOrder.wage)!
            if price == 0 {
                self.totalPriceLabel.text = "توافقی"
                self.tomanLabel.isHidden = true
                self.discountTextField.isEnabled = false
                self.discountButton.isEnabled = false
                self.discountButton.backgroundColor = .lightGray
                self.discountTextField.placeholder = "استفاده از کوپن مجاز نیست"
            } else {
                self.totalPrice = (price - discount) + wage
                self.totalPriceLabel.text = self.totalPrice!.seperateByCama
                self.tomanLabel.isHidden = false
                self.discountTextField.isEnabled = true
                self.discountButton.isEnabled = true
                self.discountButton.backgroundColor = #colorLiteral(red: 0.1244257167, green: 0.5863809586, blue: 0.9524491429, alpha: 1)
                self.discountTextField.placeholder = "کوپن تخفیف را وارد کنید"
            }
        }
    }
    
    
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderService.instance.platformOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ORDER_CELL, for: indexPath) as! OrderTableViewCell
        let platformOrder = OrderService.instance.platformOrders[indexPath.row]
        let priceDescription = platformOrder.price_description
        if let provider = self.provider {
            let replacedDescription = (priceDescription as NSString).replacingOccurrences(of: "%provider", with: provider.name)
            let price = platformOrder.product_price ?? 0
            cell.configureCell(serviceName: platformOrder.name, detail: platformOrder.description + "\n" + platformOrder.long_description + "\n" + replacedDescription, priceType: platformOrder.fixed_pricing, price: price, wage: platformOrder.wage, discount: platformOrder.discount, whyDiscount: platformOrder.why_discount, applyDiscount: platformOrder.apply_discount, enable: platformOrder.enabled, whyDisable: platformOrder.why_disabled)
        }
        cell.orderImageView.loadImageUsingCache(withUrl: BASE_URL + platformOrder.image)
        if let selectedPlatformOrder = selectedPlatformOrder {
            if platformOrder.id == selectedPlatformOrder.id {
                cell.accessoryType = .checkmark
                cellStates?[indexPath.row] = .expanded
            } else {
                cell.accessoryType = .none
                cellStates?[indexPath.row] = .collapsed
            }
        }
        if let cellStates = cellStates {
            cell.detailLabel.numberOfLines = (cellStates[indexPath.row] == .expanded) ? 0 : 3
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let platformOrder = OrderService.instance.platformOrders[indexPath.row]
        self.selectedPlatformOrder = platformOrder
        self.tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! OrderTableViewCell
        tableView.beginUpdates()
        cell.detailLabel.numberOfLines = 0
        cellStates?[indexPath.row] = .expanded
        tableView.endUpdates()
        tableViewHeightConstraint.constant = tableView.contentSize.height
        self.configureOrderUI()
    }
    
    
}
