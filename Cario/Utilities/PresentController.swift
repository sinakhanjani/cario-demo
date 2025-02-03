//
//  PresentController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

class PresentController {
    
    static let shared = PresentController()
    
    private let defaults = UserDefaults(suiteName: USER_DEFAULT_KEY)!
    
    public var IS_PRESENTED_REGISTERATION_VC: Bool {
        get {
            return defaults.bool(forKey: PRESENT_REGISTER_VC_KEY)
        }
        set {
            defaults.set(newValue, forKey: PRESENT_REGISTER_VC_KEY)
        }
    }
    
    public var IS_PRESENTED_ADD_CAR_VC: Bool {
        get {
            return defaults.bool(forKey: PRESENT_ADD_CAR_KEY)
        }
        set {
            defaults.set(newValue, forKey: PRESENT_ADD_CAR_KEY)
        }
    }
    
    public var IS_PRESENTED_WALK_TROUGHT_VC: Bool {
        get {
            return defaults.bool(forKey: PRESENT_PAGE_VIEW_CONTROLLER_KEY)
        }
        set {
            defaults.set(newValue, forKey: PRESENT_PAGE_VIEW_CONTROLLER_KEY)
        }
    }
    
    
}
