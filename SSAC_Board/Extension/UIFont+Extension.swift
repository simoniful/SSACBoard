//
//  UIFont+Extension.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/03/03.
//

import Foundation

import UIKit

extension UIFont {
    var contentFontRegular: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    
    var contentFontBold: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    var mainFontRegular: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    var mainFontBold: UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    var smallFontRegular: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
}
