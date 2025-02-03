//
//  PlatformOrder.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

struct PlatformOrder: Decodable {
    
    var id: String
    var service_id: String
    var provider_id: String
    var name: String
    var image: String
    var description: String
    var long_description: String
    var enabled: String
    var why_disabled: String
    var discount: String
    var why_discount: String
    var visible: String
    var apply_discount: String
    var dependency: String
    var fixed_pricing: String
    var product_id: String
    var price_description: String
    var wage: String
    var product_price: Int?

}
