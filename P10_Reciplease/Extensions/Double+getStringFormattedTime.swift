//
//  Double+getTime.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 17/01/2022.
//

import Foundation

extension Double {
    func getStringFormattedTime() -> String {
        switch self {
        case 0:
            return ""
        case 1 ..< 60:
            return "⏱\(String(format: "%.0f", self))m"
        case 60 ... 1000:
            let hours = self / 60
            let minutes = self.remainder(dividingBy: 60)
            if minutes != 0 {
                return "⏱\(String(format: "%.0f", hours))h \(String(format: "%.0f", minutes))m"
            } else {
                return "⏱\(String(format: "%.0f", hours))h"
            }
        default:
            return "⏱\(self)m"
        }
    }
}
