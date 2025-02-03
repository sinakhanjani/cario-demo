//
//  File.swift
//  Cario
//
//  Created by Sinakhanjani on 7/22/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct Brand: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("brand").appendingPathExtension("br")
    }
    
    var id: String
    var name: String
    var latinName: String
    var slug: String
    var isActive: Bool
    var logoName: String
    var isProductionYear: String
    var iran: String
    var models: [Model]
    
    init(id: String, name: String, latinName: String, slug: String, isActive: String, logoName: String, isProductionYear: String, iran: String, models: [Model]) {
        self.id = id
        self.name = name
        self.latinName = latinName
        self.slug = slug
        if isActive == "1" {
            self.isActive = true
        } else {
            self.isActive = false
        }
        self.logoName = logoName
        self.isProductionYear = isProductionYear
        self.iran = iran
        self.models = models
    }
    
    static func encode(saveBrand: [Brand], directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(saveBrand) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> [Brand]? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([Brand].self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
}
