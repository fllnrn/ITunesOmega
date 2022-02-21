//
//  Date.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 20.02.2022.
//

import Foundation

extension Date {
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
}
