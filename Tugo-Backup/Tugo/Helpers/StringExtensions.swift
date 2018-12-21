//
//  StringExtensions.swift
//  Tugo
//
//  Created by Alex on 22/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
