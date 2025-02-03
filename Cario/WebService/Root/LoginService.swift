//
//  LoginService.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LoginService {
    
    static let instance = LoginService()
    
    var mobileNumber: String = ""
    var userhistory: UserHistory?
    var profileContent: ProfileContent?
    var carioInit: CarioInit?
    
    func registrationRequest(mobileNumber number: String, userName name: String, userEmail email: String, sexual: Sexual, completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL) else { completion(.server) ; return }
        let parameters = ["ROUTE":"LOGIN",
                          "ACTION":"REGISTRATION",
                          "TEL":number,
                          "APP":"\(Authentication.Platform.ios.rawValue)",
                          "USER_NAME":name,
                          "USER_EMAIL":email,
                          "USER_SEX":"\(sexual.rawValue)"
        ]
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data.createDataBody(withParameters: parameters, boundary: boundary)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(.data) ; return }
            guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
            let message = json["MESSAGE"].stringValue
            switch message {
            case "DUPLICATE_TEL":
                self.userhistory = .old
                completion(.duplicate)
            case "REGISTRATION_CODE":
                self.mobileNumber = number
                self.userhistory = .new
                completion(.success)
            case "NOT_ENOUGH_DATA":
                completion(.invalidInput)
            default:
                completion(.failed)
            }
        }
        task.resume()
    }
    
    func loginRequest(mobileNumber number: String, completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL) else { completion(.server) ; return }
        let parameters = ["ROUTE":"LOGIN",
                          "ACTION":"LOGIN",
                          "TEL":number,
                          "APP":"\(Authentication.Platform.ios.rawValue)"
        ]
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data.createDataBody(withParameters: parameters, boundary: boundary)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(.data) ; return }
            guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
            let message = json["MESSAGE"].stringValue
            switch message {
            case "REGISTRATION_CODE":
                self.mobileNumber = number
                self.userhistory = .old
                completion(.success)
            case "ACCOUNT_NOT_ACTIVATED":
                completion(.noLogin)
                self.userhistory = .new
            case "NOT_ENOUGH_DATA":
                completion(.invalidInput)
            default:
                completion(.failed)
            }
        }
        task.resume()
    }
    
    
    func activationCode(mobileNumber number: String,codeNumber code: String, referrer: String?, completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL) else { completion(.server) ; return }
        var parameters = ["ROUTE":"LOGIN",
                          "ACTION":"ACTIVATION",
                          "TEL":number,
                          "APP":"\(Authentication.Platform.ios.rawValue)",
                          "CODE":code,
        ]
        if let referrer = referrer, referrer != "" {
            parameters.updateValue(referrer, forKey: "REFERRER")
        } else {
            parameters.updateValue("-1", forKey: "REFERRER")
        }
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data.createDataBody(withParameters: parameters, boundary: boundary)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { completion(.data) ; return }
            guard let json = try? JSON.init(data: data) else { completion(.json) ; return }
            let message = json["MESSAGE"].stringValue
            switch message {
            case "ACTIVATION_FAILED":
                completion(.wrongCode)
            case "ACTIVATION_SUCCESSFUL":
                // save userData
                let userId = json["USER_ID"].stringValue
                let session = json["SESSION"].stringValue
                Authentication.auth.authenticationUser(session: session, userId: userId, isLoggedIn: true, version: VERSION)
                // save userInfo
                let userName = json["USER_NAME"].stringValue
                let userEmail = json["USER_EMAIL"].stringValue
                let userSexual = json["USER_SEX"].stringValue
                let userReffererToken = json["USER_REFERRER_TOKEN"].stringValue
                let userPurse = json["USER_PURSE"].stringValue
                let userRating = json["USER_RATING"].stringValue
                let userType = json["USER_TYPE"].stringValue
                let userShopingPrice = json["SHOPPING_PRIZE_WITH_PURSE"].stringValue
                let userInformation = UserInformation(userName: userName, userEmail: userEmail, userSexual: userSexual, userReferrerToken: userReffererToken, userPurse: userPurse, userRate: userRating, userType: userType, userShopPrice: userShopingPrice, userMobile: number, userId: userId)
                UserInformation.encode(saveInfo: userInformation, directory: UserInformation.archiveURL) // save^ UserInformation
                // UserCars
                if let userCars = json["USER_CARS"].array {
                    var cars = [Car]()
                    for car in userCars {
                        // CarInfo
                        let id = car["id"].stringValue
                        let carModelId = car["car_model_id"].stringValue
                        let carTeepId = car["car_teep_id"].stringValue
                        let userId = car["user_id"].stringValue
                        let isActive = car["is_active"].stringValue
                        let date = car["date"].stringValue
                        let year = car["year"].stringValue
                        // Carbrand
                        let carBrands = car["OUTPUT_CAR_BRAND"].dictionaryValue
                        let carId = carBrands["id"]!.stringValue
                        let name = carBrands["name"]!.stringValue
                        let latin_name = carBrands["latin_name"]!.stringValue
                        let slug = carBrands["slug"]!.stringValue
                        let is_active = carBrands["is_active"]!.stringValue
                        let logo_name = carBrands["logo_name"]!.stringValue
                        let is_production_year_jalali = carBrands["is_production_year_jalali"]!.stringValue
                        let iran = carBrands["iran"]!.stringValue
                        let carBrand = CarBrand(id: carId, name: name, latinName: latin_name, slug: slug, isActive: is_active, logoName: logo_name, isProductionYear: is_production_year_jalali, iran: iran)
                        // CarModel
                        let carModels = car["OUTPUT_CAR_MODEL"].dictionaryValue
                        let model_id = carModels["id"]!.stringValue
                        let model_brand_id = carModels["brand_id"]!.stringValue
                        let model_name = carModels["name"]!.stringValue
                        let model_latin_name = carModels["latin_name"]!.stringValue
                        let model_slug = carModels["slug"]!.stringValue
                        let model_is_active = carModels["is_active"]!.stringValue
                        let model_size = carModels["size"]!.stringValue
                        let carModel = CarModel(id: model_id, brandId: model_brand_id, name: model_name, latinName: model_latin_name, slug: model_slug, isActive: model_is_active, size: model_size)
                        // CarTeep
                        var carTeep: CarTeep?
                        if let carTeeps = car["OUTPUT_CAR_TEEP"].dictionary {
                            let teep_id = carTeeps["id"]!.stringValue
                            let teep_model_id = carTeeps["model_id"]!.stringValue
                            let teep_name = carTeeps["name"]!.stringValue
                            let teep_latin_name = carTeeps["latin_name"]!.stringValue
                            let teep_slug = carTeeps["slug"]!.stringValue
                            let teep_oil_capacity = carTeeps["motor_oil_capacity"]!.stringValue
                            let teep_oil_capacity_not_filter_change = carTeeps["motor_oil_capacity_not_filter_change"]!.stringValue
                            let teep_wage_ratio = carTeeps["wage_ratio"]!.stringValue
                            let teep_is_active = carTeeps["is_active"]!.stringValue
                            carTeep = CarTeep(id: teep_id, modelId: teep_model_id, name: teep_name, latinName: teep_latin_name, slug: teep_slug, motorOilCapacity: teep_oil_capacity, motorOilCapacityNoFilterChange: teep_oil_capacity_not_filter_change, wageRatio: teep_wage_ratio, isActive: teep_is_active)
                            let car = Car(id: id, carModelId: carModelId, carTeepId: carTeepId, userId: userId, isActive: isActive, date: date, year: year, carBrand: carBrand, carModel: carModel, carTeep: carTeep)
                            cars.append(car)
                        } else {
                            carTeep = CarTeep(id: "1", modelId: model_id, name: "", latinName: "", slug: "", motorOilCapacity: "", motorOilCapacityNoFilterChange: "", wageRatio: "", isActive: "1")
                            let car = Car(id: id, carModelId: carModelId, carTeepId: carTeepId, userId: userId, isActive: isActive, date: date, year: year, carBrand: carBrand, carModel: carModel, carTeep: carTeep)
                            cars.append(car)
                        }
                    }
                    // save Cars array to database
                    Car.encode(save: cars, directory: Car.archiveURL) // save^ Car
                }
                completion(.success)
            default:
                completion(.failed)
            }
        }
        task.resume()
    }
    
    func profileUpRequest(completion: @escaping COMPLETION_HANDLER) {
        var orderObjects = [OrderObjcet]()
        guard let url = URL(string: BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=ROUTE_PROFILE&ACTION=PROFILE_GET_ALL") else { completion(.network) ; return }
        // guard let url = URL(string: "http://app.cario.ir/?ROUTE=ROUTE_PROFILE&ACTION=PROFILE_GET_ALL&APP=1&SESSION=8104946f63a963ae81c33a1911b9745a83e508ec7d1b025e1c04f509ec87f4b9&USER_ID=1&VERSION=8") else { completion(.network) ; return }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON(data: data) else { completion(.json) ; return }
                let profileContent = json["ProfileContent"].dictionaryValue
                let id = profileContent["id"]!.stringValue
                let tel = profileContent["tel"]!.stringValue
                let fname = profileContent["fname"]!.stringValue
                let lname = profileContent["lname"]!.stringValue
                let avatar = profileContent["avatar"]!.stringValue
                let gender = profileContent["gender"]!.stringValue
                let email = profileContent["email"]!.stringValue
                let purse = profileContent["purse"]!.stringValue
                let rating = profileContent["rating"]!.stringValue
                let image = profileContent["image"]!.stringValue
                let userName = profileContent["username"]!.stringValue
                let orderObject = json["OrdersObject"].array
                if let orderObject = orderObject {
                    for order in orderObject {
                        let order_id = order["id"].stringValue
                        let date = order["date"].stringValue
                        let timeName = order["timeName"].stringValue
                        let price = order["price"].stringValue
                        let discount = order["discount"].stringValue
                        let finalprice = order["finalprice"].stringValue
                        let providerName = order["providerName"].stringValue
                        let providerImage = order["providerImage"].stringValue
                        let providerDescription = order["providerDescription"].stringValue
                        let productName = order["productName"].stringValue
                        let order = OrderObjcet.init(id: order_id, date: date, timeName: timeName, price: price, discount: discount, finalPrice: finalprice, providerName: providerName, providerImage: providerImage, providerDescription: providerDescription, productName: productName)
                        orderObjects.append(order)
                    }
                    let profile_Content = ProfileContent.init(id: id, tel: tel, fname: fname, lname: lname, avatar: avatar, gender: gender, email: email, purse: purse, rating: rating, image: image, orderObject: orderObjects, userName: userName)
                    self.profileContent = profile_Content
                } else {
                    let profile_Content = ProfileContent.init(id: id, tel: tel, fname: fname, lname: lname, avatar: avatar, gender: gender, email: email, purse: purse, rating: rating, image: image, orderObject: nil, userName: userName)
                    self.profileContent = profile_Content
                }

                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    func fetchInitRequest(tip: String, completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL + "?\(Authentication.auth.authQuery)" + "&LAST_TIP_ID=\(tip)&ROUTE=INIT") else { completion(.server) ; return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let data = data else { completion(.data) ; return }
                guard let carioInit = try? JSONDecoder().decode(CarioInit.self, from: data) else { completion(.json) ; return }
                self.carioInit = carioInit
                completion(.success)
            } else {
                completion(.server)
            }
        }.resume()
    }
    
    
    
}
