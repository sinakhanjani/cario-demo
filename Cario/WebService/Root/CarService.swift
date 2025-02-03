//
//  CarService.swift
//  Cario
//
//  Created by Sinakhanjani on 7/22/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CarService {
    
    static let instance = CarService()
    
    var carPrices = [CarPrice]()
    
    func getAllCarRequest(completion: @escaping COMPLETION_HANDLER) {
        var teeps = [Teep]()
        var models = [Model]()
        var allBrands = [Brand]()
        guard let url = URL(string: BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=USER_CARS&ACTION=GET_ALL_CARS") else { completion(.network) ; return }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let brands = try? JSON.init(data: data).array else { completion(.json) ; return }
                guard let brand_s = brands else { completion(.data) ; return }
                for brand in brand_s {
                    let carId = brand["id"].stringValue
                    let name = brand["name"].stringValue
                    let latin_name = brand["latin_name"].stringValue
                    let slug = brand["slug"].stringValue
                    let is_active = brand["is_active"].stringValue
                    let logo_name = brand["logo_name"].stringValue
                    let is_production_year_jalali = brand["is_production_year_jalali"].stringValue
                    let iran = brand["iran"].stringValue
                    // Car model array decode
                    let carModels = brand["CAR_MODEL"].arrayValue
                    for carModel in carModels {
                        let model_id = carModel["id"].stringValue
                        let model_brand_id = carModel["brand_id"].stringValue
                        let model_name = carModel["name"].stringValue
                        let model_latin_name = carModel["latin_name"].stringValue
                        let model_slug = carModel["slug"].stringValue
                        let model_is_active = carModel["is_active"].stringValue
                        let model_size = carModel["size"].stringValue
                        // Car teeps array decode
                        let carTeeps = carModel["CAR_TEEP"].arrayValue
                        for teep in carTeeps {
                            let teep_id = teep["id"].stringValue
                            let teep_model_id = teep["model_id"].stringValue
                            let teep_name = teep["name"].stringValue
                            let teep_latin_name = teep["latin_name"].stringValue
                            let teep_slug = teep["slug"].stringValue
                            let teep_oil_capacity = teep["motor_oil_capacity"].stringValue
                            let teep_oil_capacity_not_filter_change = teep["motor_oil_capacity_not_filter_change"].stringValue
                            let teep_wage_ratio = teep["wage_ratio"].stringValue
                            let teep_is_active = teep["is_active"].stringValue
                            let carTeep = Teep(id: teep_id, modelId: teep_model_id, name: teep_name, latinName: teep_latin_name, slug: teep_slug, motorOilCapacity: teep_oil_capacity, motorOilCapacityNoFilterChange: teep_oil_capacity_not_filter_change, wageRatio: teep_wage_ratio, isActive: teep_is_active)
                            teeps.append(carTeep) // append
                        }
                        let _carModel = Model(id: model_id, brandId: model_brand_id, name: model_name, latinName: model_latin_name, slug: model_slug, isActive: model_is_active, size: model_size, teeps: teeps)
                        models.append(_carModel)
                    }
                    let _carBrand = Brand(id: carId, name: name, latinName: latin_name, slug: slug, isActive: is_active, logoName: logo_name, isProductionYear: is_production_year_jalali, iran: iran, models: models)
                    allBrands.append(_carBrand)
                    models.removeAll()
                    teeps.removeAll()
                }
                Brand.encode(saveBrand: allBrands, directory: Brand.archiveURL) // save^ Brands
                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    func userCarRequest(teepId: String, modelId: String, year: String, completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL + "?\(Authentication.auth.authQuery)" + "&TEEP_ID=\(teepId)&ROUTE=USER_CARS&ACTION=REGISTER_NEW_CAR&MODEL_ID=\(modelId)&YEAR=\(year)") else { completion(.network) ; return }
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON(data: data) else { completion(.json) ; return }
                let message = json["MESSAGE"].stringValue
                if message == "SUCCESS" {
                    completion(.success)
                } else {
                    completion(.failed)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func fetchCarPrices(completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=CAR_PRICING") else { completion(.server) ; return }
        self.carPrices.removeAll()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let data = data else { completion(.data) ; return }
                guard let carPrices = try? JSONDecoder().decode([CarPrice].self, from: data) else { completion(.json) ; return }
                self.carPrices = carPrices
                completion(.success)
            } else {
                completion(.server)
            }
        }.resume()
    }

 

}
