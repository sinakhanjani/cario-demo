//
//  OrderService.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderService {
    
    static let instance = OrderService()
    
    var platformOrders = [PlatformOrder]()
    var orderCode: String?
    var discountCopon: String?
    var discountCode: String?

    func fetchPlatformOrder(serviceId: String, providerId: String, userCarId: String,completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ACTION=GET_PRODUCTS&ROUTE=PLATFORM_ORDER&SERVICE=\(serviceId)&SERVICE_PROVIDER=\(providerId)&USER_CAR=\(userCarId)"
        self.platformOrders.removeAll()
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data); return }
                guard let json = try? JSON.init(data: data).array else { completion(.json); return }
                guard let jsonArray = json else { completion(.failed); return }
                for json in jsonArray {
                    let id = json["id"].stringValue
                    let service_id = json["service_id"].stringValue
                    let provider_id = json["provider_id"].stringValue
                    let name = json["name"].stringValue
                    let image = json["image"].stringValue
                    let description = json["description"].stringValue
                    let long_description = json["long_description"].stringValue
                    let enabled = json["enabled"].stringValue
                    let why_disabled = json["why_disabled"].stringValue
                    let discount = json["discount"].stringValue
                    let why_discount = json["why_discount"].stringValue
                    let visible = json["visible"].stringValue
                    let apply_discount = json["apply_discount"].stringValue
                    let dependency = json["dependency"].stringValue
                    let fixed_pricing = json["fixed_pricing"].stringValue
                    let product_id = json["product_id"].stringValue
                    let price_description = json["price_description"].stringValue
                    let wage = json["wage"].stringValue
                    if let product_price = json["product_price"].int {
                        let platformOrder = PlatformOrder.init(id: id, service_id: service_id, provider_id: provider_id, name: name, image: image, description: description, long_description: long_description, enabled: enabled, why_disabled: why_disabled, discount: discount, why_discount: why_discount, visible: visible, apply_discount: apply_discount, dependency: dependency, fixed_pricing: fixed_pricing, product_id: product_id, price_description: price_description, wage: wage, product_price: product_price)
                        self.platformOrders.append(platformOrder)
                    } else if let product_price = json["product_price"].string {
                        let platformOrder = PlatformOrder.init(id: id, service_id: service_id, provider_id: provider_id, name: name, image: image, description: description, long_description: long_description, enabled: enabled, why_disabled: why_disabled, discount: discount, why_discount: why_discount, visible: visible, apply_discount: apply_discount, dependency: dependency, fixed_pricing: fixed_pricing, product_id: product_id, price_description: price_description, wage: wage, product_price: Int(product_price))
                        self.platformOrders.append(platformOrder)
                    }
                }
                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    func checkDiscount(lat: String, long: String, providerId: String, serviceId: String, discount: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ACTION=CHECK_DISCOUNT&DISCOUNT=\(discount)&LATITUDE=\(lat)&LONGITUDE=\(long)&ROUTE=DISCOUNT&SERVICE=\(serviceId)&SERVICE_PROVIDER=\(providerId)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                self.discountCopon = nil
                self.discountCode = nil
                guard let data = response.data else { completion(.data); return }
                guard let json = try? JSON.init(data: data) else { completion(.json); return }
                let message = json["MESSAGE"].stringValue
                if message == "VALID_DISCOUNT" {
                    self.discountCopon = json["DISCOUNT"].stringValue
                    self.discountCode = json["DISCOUNT_CODE"].stringValue
                    completion(.VALID_DISCOUNT)
                } else if message == "INVALID_MAX_DISTANCE_DISCOUNT" {
                    completion(.NVALID_MAX_DISTANCE_DISCOUNT)
                } else if message == "INVALID_MAX_USAGE_DISCOUNT" {
                    completion(.INVALID_MAX_USAGE_DISCOUNT)
                } else if message == "INVALID_DISCOUNT" {
                    completion(.INVALID_DISCOUNT)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func submitOrder(address: String, amount: String, comment: String, date: String, time: String, discount: String, discountCode: String, finalAmount: String, lat: String, long: String, productId: String, serviceId: String, providerId: String, userCarId: String,completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ACTION=NEW&ADDRESS=\(address)&AMOUNT=\(amount)&COMMENT=\(comment)&DATE=\(date)&TIME=\(time)&DISCOUNT=\(discount)&DISCOUNT_CODE=\(discountCode)&FINAL_AMOUNT=\(finalAmount)&LATITUDE=\(lat)&LONGITUDE=\(long)&ORDER_ZOOM=15.0&PAYMENT_METHOD=1&PRODUCT_ID=\(productId)&ROUTE=PLATFORM_ORDER&SERVICE=\(serviceId)&SERVICE_PROVIDER=\(providerId)&USER_CAR=\(userCarId)"
        guard let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { completion(.server) ; return }
        print(url)
        Alamofire.request(encodeURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                self.orderCode = nil
                guard let data = response.data else { completion(.data); return }
                guard let json = try? JSON.init(data: data) else { completion(.json); return }
                if let message = json["MESSAGE"].string {
                    if message == "SUCCESSFULL_ORDER" {
                        let orderCode = json["ORDER_CODE"].stringValue
                        self.orderCode = orderCode
                        completion(.SUCCESSFULL_ORDER)
                    } else {
                        completion(.FAILED_ORDER)
                    }
                } else {
                    completion(.server)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func payFromPurse(orderId: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ACTION=ACTION_START_PAYMENT_PURSE&ORDER_ID=\(orderId)&ROUTE=PLATFORM_ORDER"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseString { (response) in
            if response.result.error == nil {
                guard let message = response.value else { completion(.server) ; return }
                if message == "DONE" {
                    completion(.donePay)
                } else if message == "NOT_ENOUGH" {
                    completion(.notEnoughtToPay)
                } else {
                    completion(.failed)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func payFromBank(orderId: String) {
        let url = URL.init(string: "\(BASE_URL)?ROUTE=PLATFORM_ORDER&ACTION=START_PAYMENT&ORDER_ID=\(orderId)")
        if let openURL = url {
            DispatchQueue.main.async {
                UIApplication.shared.open(openURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
