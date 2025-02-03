//
//  CarTeep.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct CarTeep: Codable {
    var id: String
    var modelId: String
    var name: String
    var latinName: String
    var slug: String
    var motorOilCapacity: String
    var motorOilCapacityNoFilterChange: String
    var wageRatio: String
    var isActive: Bool
    
    init(id: String, modelId: String, name: String, latinName: String, slug: String, motorOilCapacity: String,motorOilCapacityNoFilterChange: String, wageRatio: String, isActive: String) {
        self.id = id
        self.modelId = modelId
        self.name = name
        self.latinName = latinName
        self.slug = slug
        self.motorOilCapacity = motorOilCapacity
        self.motorOilCapacityNoFilterChange = motorOilCapacityNoFilterChange
        self.wageRatio = wageRatio
        if isActive == "1" {
            self.isActive = true
        } else {
            self.isActive = false
        }
    }
}
