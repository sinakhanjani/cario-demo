//
//  CarModel.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct CarModel: Codable {
    var id: String
    var brandId: String
    var name: String
    var latinName: String
    var slug: String
    var isActive: Bool
    var size : String
    
    init(id: String, brandId: String, name: String, latinName: String, slug: String, isActive: String, size: String) {
        self.id = id
        self.brandId = brandId
        self.name = name
        self.latinName = latinName
        self.slug = slug
        if isActive == "1" {
            self.isActive = true
        } else {
            self.isActive = false
        }
        self.size = size
    }
}


