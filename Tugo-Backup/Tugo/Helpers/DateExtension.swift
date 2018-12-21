//
//  MonthsSpanishEnum.swift
//  Tugo
//
//  Created by Alex on 2/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}


