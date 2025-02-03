//
//  PaymentService.swift
//  Cario
//
//  Created by Sinakhanjani on 7/23/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PaymentService {
    
    static let instance = PaymentService()
    
    func chargeCredit(money: String) {
        let openURL = URL.init(string: "http://app.cario.ir/?ROUTE=ROUTE_PURSE&ACTION=PURSE_ADD&APP=\(Authentication.Platform.ios.rawValue)&SESSION=\(Authentication.auth.session)&USER_I\(Authentication.auth.userId)&AMOUNT=\(money)")
        if let openURL = openURL {
            DispatchQueue.main.async {
                UIApplication.shared.open(openURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
