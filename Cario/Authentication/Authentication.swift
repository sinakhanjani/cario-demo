//
//  File.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//
import Foundation

class Authentication {
    
    static let auth = Authentication()
    
    enum Platform: Int {
        case none, android, ios
    }
        
    let defaults = UserDefaults(suiteName: USER_DEFAULT_KEY)!
    
    private var _isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: IS_LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: IS_LOGGED_IN_KEY)
        }
    }
    private var _session: String {
        get {
            return defaults.value(forKey: SESSION_KEY) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: SESSION_KEY)
        }
    }
    private var _userId: String {
        get {
            return defaults.value(forKey: USER_ID_KEY) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: USER_ID_KEY)
        }
    }
    private var _version: String {
        get {
            return defaults.value(forKey: VERSION_KEY) as? String ?? ""
        }
        set {
            defaults.set(newValue, forKey: VERSION_KEY)
        }
    }
    
    public var isLoggedIn: Bool {
        return _isLoggedIn
    }
    
    public var session: String {
        return _session
    }
    
    public var version: String {
        return _version
    }
    
    public var userId: String {
        return _userId
    }
    
    public var authQuery: String {
        return "&APP=\(Platform.ios.rawValue)&SESSION=\(_session)&USER_ID=\(_userId)&VERSION=\(_version)"
    }
    
    public func authenticationUser(session: String, userId: String, isLoggedIn: Bool, version: String) {
        self._version = version
        self._session = session
        self._userId = userId
        self._isLoggedIn = isLoggedIn
    }
    
    public func logOutAuth() {
        self._isLoggedIn = false
        self._session = ""
        self._userId = ""
        defaults.set(false, forKey: PRESENT_REGISTER_VC_KEY)
        defaults.set(false, forKey: PRESENT_ADD_CAR_KEY)
        UserDefaults.standard.set(0, forKey: SELECTED_CAR_INDEX_KEY)
        DataManager.shared.cars = nil
        DataManager.shared.allCarBrands = nil
        DataManager.shared.userInformation = nil
        UserDefaults.standard.set(1, forKey: TIP_KEY)
        UserDefaults.standard.set(0, forKey: MESSAGE_SINGLE_ID_KEY)
        UserDefaults.standard.set(false, forKey: FIRST_TIME_RULES_AND_POLICY)
        UserDefaults.standard.set(false, forKey: PRESENT_PAGE_VIEW_CONTROLLER_KEY)
    }
    
    
}
