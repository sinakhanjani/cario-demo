//
//  UIFontExtension.swift
//  Cario
//
//  Created by Sinakhanjani on 7/20/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func iranSansFont(size: CGFloat) -> UIFont {
        return UIFont(name: IRAN_SANS_MOBILE_FONT, size: size)!
    }
    
    static func iranSansBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: size)!
    }

}
