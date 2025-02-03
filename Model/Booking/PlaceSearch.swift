//
//  PlaceSearch.swift
//  Cario
//
//  Created by Sinakhanjani on 8/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct PlaceSearch: Codable {
    let id, category, title, area: String
    let address: String
    let image: String
    let phone, rate, ratesCount, description: String
    let latitude, longitude, distance: String
    
    enum CodingKeys: String, CodingKey {
        case id, category, title, area, address, image, phone, rate
        case ratesCount = "rates_count"
        case description, latitude, longitude, distance
    }
}

