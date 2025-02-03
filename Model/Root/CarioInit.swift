//
//  CarioJson.swift
//  SwiftDemoApp
//
//  Created by Teodik Abrami on 10/12/18.
//  Copyright © 2018 Google. All rights reserved.
//

import Foundation

struct CarioInit: Decodable {
    let services: [Service]
    let tips: [Tip]
    let version: Version
    let firstOrder: FirstOrder
    let messageSingle: MessageSingle?
    let userRating: UserRating
    let referrerPrize: String
    
    enum CodingKeys: String, CodingKey {
        case services = "SERVICES"
        case tips = "TIPS"
        case version = "VERSION"
        case firstOrder = "FIRST_ORDER"
        case messageSingle = "MESSAGE_SINGLE"
        case userRating = "USER_RATING"
        case referrerPrize = "REFERRER_PRIZE"
    }
}

struct MessageSingle: Decodable {
    let id: String
    let title: String
    let shortMessage: String
    let message: String
    let target: String
    let image: String
    let lottieUrl: String
    let isLottie: String
    let hasMore: String
    let needShow: String
}

struct Tip: Codable {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("tip").appendingPathExtension("tp")
    }
    
    let tip_id: String
    let tip_meesage: String
    let tip_views: String
    let tip_date: String
    let tip_car_model: String
    let tip_car_brand: String
    let tip_car_teep: String
    let visible: String
    
    enum CodingKeys: String, CodingKey {
        case tip_id = "tip_id"
        case tip_meesage = "tip_meesage"
        case tip_views = "tip_views"
        case tip_date = "tip_date"
        case tip_car_model = "tip_car_model"
        case tip_car_brand = "tip_car_brand"
        case tip_car_teep = "tip_car_teep"
        case visible = "visible"
    }
    
    static func encode(tips: [Tip], directory dir: URL) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedProduct = try? propertyListEncoder.encode(tips) {
            try? encodedProduct.write(to: dir, options: .noFileProtection)
        }
    }
    
    static func decode(directory dir: URL) -> [Tip]? {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedProductData = try? Data.init(contentsOf: dir), let decodedProduct = try? propertyListDecoder.decode([Tip].self, from: retrievedProductData) {
            return decodedProduct
        }
        return nil
    }
}

struct FirstOrder: Decodable {
    let firstOrder, hasReferrer, discount, discountCode: Int
    let orderCount: Int
    
    enum CodingKeys: String, CodingKey {
        case firstOrder = "FIRST_ORDER"
        case hasReferrer = "HAS_REFERRER"
        case discount = "DISCOUNT"
        case discountCode = "DISCOUNT_CODE"
        case orderCount = "ORDER_COUNT"
    }
}

struct Service: Decodable {
    let servicesCategoryID, name: String
    let service: [ServiceElement]
    
    enum CodingKeys: String, CodingKey {
        case servicesCategoryID = "services_category_id"
        case name, service
    }
}

struct ServiceElement: Decodable {
    let servicesCategoryID, serviceID, name, image: String
    let description, enabled, visible, serviceType: String
    let spanCount, target, orderCell: String
    let provider: [Provider]
    let notes: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case servicesCategoryID = "services_category_id"
        case serviceID = "service_id"
        case name, image, description, enabled, visible
        case serviceType = "service_type"
        case spanCount, target, orderCell, provider
        case notes = "Notes"
    }
}

struct Provider: Decodable {
    let serviceID, providerID, name, image: String
    let description, longDescription, verified, enabled: String
    let whyDisabled, discount, whyDiscount, startWorkHour: String
    let endWorkHour, splitHour, nextDaysOrder, visible: String
    let rating, serverSort: String
    let serviceArea: [ServiceArea]
    
    enum CodingKeys: String, CodingKey {
        case serviceID = "service_id"
        case providerID = "provider_id"
        case name, image, description
        case longDescription = "long_description"
        case verified, enabled
        case whyDisabled = "why_disabled"
        case discount
        case whyDiscount = "why_discount"
        case startWorkHour = "start_work_hour"
        case endWorkHour = "end_work_hour"
        case splitHour = "split_hour"
        case nextDaysOrder = "next_days_order"
        case visible, rating
        case serverSort = "server_sort"
        case serviceArea = "service_area"
    }
}

struct ServiceArea: Decodable {
    let id, name: String
    let color: Color
    let available, providerID: String
    let points: [Point]
    
    enum CodingKeys: String, CodingKey {
        case id, name, color, available
        case providerID = "provider_id"
        case points
    }
}

enum Color: String, Decodable {
    case the5500Bdf2 = "5500bdf2"
}

struct Point: Decodable {
    let latitude, longitude: String
}

struct UserRating: Decodable {
    let rating, purse: String
}

struct Version: Decodable {
    let version, minVersion: Int
    let updateURL: String
    
    enum CodingKeys: String, CodingKey {
        case version = "VERSION"
        case minVersion = "MIN_VERSION"
        case updateURL = "UPDATE_URL"
    }
}

