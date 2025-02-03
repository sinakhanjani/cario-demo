//
//  CarBrand.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct CarBrand: Codable {
    var id: String
    var name: String
    var latinName: String
    var slug: String
    var isActive: Bool
    var logoName: String
    var isProductionYear: String
    var iran: String
    
    init(id: String, name: String, latinName: String, slug: String, isActive: String, logoName: String, isProductionYear: String, iran: String) {
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
    }
}
