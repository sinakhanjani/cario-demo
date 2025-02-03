//
//  Enumerated.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

enum Sexual: Int {
    case none, male, female
}

enum Alert {
    case none, success, failed, server, network, invalidInput, duplicate, json, data, noLogin, wrongCode, INVALID_MAX_USAGE_DISCOUNT, NVALID_MAX_DISTANCE_DISCOUNT, SYSTEM_ERROR, SUCCESSFULL_ORDER, FAILED_ORDER, VALID_DISCOUNT, INVALID_DISCOUNT, donePay, notEnoughtToPay
}

enum Activation: Int {
    case none, active, deActive
}

enum SideMenuItem {
    case none, pm, aboutUs, callUs, question, rateUp, rules, exit
}

enum UserHistory {
    case old, new
}

enum Exapandable {
    case expand, unExpand
}

enum DynamticSegue: String {
    case khalafi = "page.platform.KhalafiActivity"
    case nomreManfi = "page.platform.NomreManfiActivity"
    case nerkhKhodro = "page.platform.CarPricingActivity"
    case emdadKhodro = "page.platform.EmdadActivity"
}

