//
//  Cars.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct Car: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("carInfo").appendingPathExtension("cr")
    }
    
    var id: String
    var carModelId: String
    var carTeepId: String
    var userId: String
    var isActive: Bool
    var date: String
    var year: String
    var carBrand: CarBrand?
    var carModel: CarModel?
    var carTeep: CarTeep?
    
    init(id: String, carModelId: String, carTeepId: String, userId: String, isActive: String, date: String, year: String, carBrand: CarBrand?, carModel: CarModel?, carTeep: CarTeep?) {
        self.id = id
        self.carModelId = carModelId
        self.carTeepId = carTeepId
        self.userId = userId
        if isActive == "1" {
            self.isActive = true
        } else {
            self.isActive = false
        }
        self.date = date
        self.year = year
        self.carBrand = carBrand
        self.carModel = carModel
        self.carTeep = carTeep
    }
    
    static func encode(save: [Car], directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(save) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> [Car]? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([Car].self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }

}
