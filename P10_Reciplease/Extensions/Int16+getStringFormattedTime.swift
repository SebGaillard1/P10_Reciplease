//
//  Double+getTime.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 17/01/2022.
//

import Foundation

extension Int16 {
    func getStringFormattedTime() -> String {
        switch self {
        case 0:
            return ""
        case 1 ..< 60:
            return "⏱\(self)m"
        case 60 ... 1000:
            let hours = self / 60
            let minutes = self % 60
            if minutes != 0 {
                return "⏱\(hours)h \(minutes)m"
            } else {
                return "⏱\(hours)h"
            }
        default:
            return "⏱\(self)m"
        }
    }
}
