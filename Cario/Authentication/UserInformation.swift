//
//  UserInformation.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation

class UserInformation: NSObject, NSCoding {
    
    static public var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userInfo").appendingPathExtension("inf")
    }
    
    var use_id: String
    var user_name: String
    var user_mobile: String
    var user_email: String
    var user_sexual: Sexual
    var user_referrer_token: String
    var user_purse: String
    var user_rating: String
    var user_type: String
    var shoping_prize_with_purse: String
    
    struct propertyKeys {
        static let use_id = "use_id"
        static let user_name = "user_name"
        static let user_mobile = "user_mobile"
        static let user_email = "user_email"
        static let user_sexual = "user_sexual"
        static let user_referrer_token = "user_referrer_token"
        static let user_purse = "user_purse"
        static let user_rating = "user_rating"
        static var user_type = "user_type"
        static var shoping_prize_with_purse = "shoping_prize_with_purse"
    }
    
    init(userName: String, userEmail: String, userSexual: String, userReferrerToken: String, userPurse: String, userRate: String, userType: String, userShopPrice: String, userMobile: String, userId: String) {
        self.use_id = userId
        self.user_name = userName
        self.user_mobile = userMobile
        self.user_email = userEmail
        if userSexual == "1" {
            self.user_sexual = .male
        } else {
            self.user_sexual = .female
        }
        self.user_referrer_token = userReferrerToken
        self.user_purse = userPurse
        self.user_rating = userRate
        self.user_type = userType
        self.shoping_prize_with_purse = userShopPrice
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_sexual.rawValue, forKey: propertyKeys.user_sexual)
        aCoder.encode(use_id, forKey:propertyKeys.use_id)
        aCoder.encode(user_name, forKey:propertyKeys.user_name)
        aCoder.encode(user_mobile, forKey:propertyKeys.user_mobile)
        aCoder.encode(user_email, forKey:propertyKeys.user_email)
        aCoder.encode(user_purse, forKey:propertyKeys.user_purse)
        aCoder.encode(user_type, forKey:propertyKeys.user_type)
        aCoder.encode(user_rating, forKey:propertyKeys.user_rating)
        aCoder.encode(user_referrer_token, forKey:propertyKeys.user_referrer_token)
        aCoder.encode(shoping_prize_with_purse, forKey:propertyKeys.shoping_prize_with_purse)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let user_sexual = Sexual(rawValue: (aDecoder.decodeInteger(forKey: propertyKeys.user_sexual))),
            let user_name = aDecoder.decodeObject(forKey: propertyKeys.user_name) as? String,
            let user_id = aDecoder.decodeObject(forKey: propertyKeys.use_id) as? String,
            let user_mobile = aDecoder.decodeObject(forKey: propertyKeys.user_mobile) as? String,
            let user_email = aDecoder.decodeObject(forKey: propertyKeys.user_email) as? String,
            let user_purse = aDecoder.decodeObject(forKey: propertyKeys.user_purse) as? String,
            let user_type = aDecoder.decodeObject(forKey: propertyKeys.user_type) as? String,
            let user_rating = aDecoder.decodeObject(forKey: propertyKeys.user_rating) as? String,
            let shoping_prize_with_purse = aDecoder.decodeObject(forKey: propertyKeys.shoping_prize_with_purse) as? String,
            let user_referrer_token = aDecoder.decodeObject(forKey: propertyKeys.user_referrer_token) as? String else { return nil }
        let userSexual = (user_sexual == .male) ? "1": "2"
        self.init(userName: user_name, userEmail: user_email, userSexual: userSexual, userReferrerToken: user_referrer_token, userPurse: user_purse, userRate: user_rating, userType: user_type, userShopPrice: shoping_prize_with_purse, userMobile: user_mobile, userId: user_id)
    }
    
    static func encode(saveInfo info: UserInformation, directory dir: URL) {
        NSKeyedArchiver.archiveRootObject(info, toFile: dir.path)
    }
    
    static func decode(directory dir: URL) -> UserInformation? {
        guard let unarchive = NSKeyedUnarchiver.unarchiveObject(withFile: dir.path) as? UserInformation else { return nil }
        return unarchive
    }
    
    
}



