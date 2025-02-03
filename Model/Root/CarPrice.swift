//
//  CarPrice.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct CarPrice: Decodable {
    
    var brandName: String
    var modelName: String
    var year: String
    var comments: String
    var marketPrice: String
    var marketChange: String
    var agentPrice: String
    var agentChange: String
    var lastUpdate: String
    var carioUpdate: String
    var image: String
    var carSort: String

}
