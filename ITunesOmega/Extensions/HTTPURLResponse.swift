//
//  HTTPURLResponse.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 19.02.2022.
//

import Foundation

extension HTTPURLResponse {
    var isSuccessStatusCode: Bool {
        (200...299).contains(statusCode)
    }
}
