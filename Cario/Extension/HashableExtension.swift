//
//  HashableExtension.swift
//  Cario
//
//  Created by Sinakhanjani on 7/22/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

extension Int {
    
    var seperateByCama: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: self)
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
    
    
}

extension String {
    
    var seperateByCama: String {
        guard self != "0" && self != "" else { return "صفـر" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: Int(self)!)
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
    
    
}
