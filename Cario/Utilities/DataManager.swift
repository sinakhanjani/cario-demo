//
//  ConditionController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/21/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    // User Information
    public var userInformation: UserInformation? {
        get {
            return UserInformation.decode(directory: UserInformation.archiveURL)
        }
        set {
            if let encode = newValue {
                UserInformation.encode(saveInfo: encode, directory: UserInformation.archiveURL)
            }
        }
    }
    
    // User Car Information
    public var cars: [Car]? { // user cars
        get {
            return Car.decode(directory: Car.archiveURL)
        }
        set {
            if let encode = newValue {
                Car.encode(save: encode, directory: Car.archiveURL)
            }
        }
    }
    public var selectedCar: Car? { // user selected car
        get {
            guard let cars = cars, cars.count != 0 else { return nil }
            return cars[UserDefaults.standard.integer(forKey: SELECTED_CAR_INDEX_KEY)]
        }
        set {
            //
        }
    }
    
    // All Cars Brands for Xibs and addCarViewController
    public var carBrand: Brand?
    public var allCarBrands: [Brand]? {
        get {
            return Brand.decode(directory: Brand.archiveURL)
        }
        set {
            if let encode = newValue {
                Brand.encode(saveBrand: encode, directory: Brand.archiveURL)
            }
        }
    }
    
    // MessageId
    public var messageId: Int {
        get {
            return UserDefaults.standard.integer(forKey: MESSAGE_SINGLE_ID_KEY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MESSAGE_SINGLE_ID_KEY)
        }
    }

    // Rules and Policy
    public var firstTimeRulesAndPolicy: Bool {
        get {
            return UserDefaults.standard.bool(forKey: FIRST_TIME_RULES_AND_POLICY)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: FIRST_TIME_RULES_AND_POLICY)
        }
    }
    

}
