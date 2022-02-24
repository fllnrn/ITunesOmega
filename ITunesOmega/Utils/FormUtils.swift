//
//  FormUtils.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 24.02.2022.
//

import Foundation

func isPasswordValid(_ password: String) -> Bool {
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,255}$")
    return passwordTest.evaluate(with: password)
}
func isEmailValid(_ email: String) -> Bool {
    let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
    return emailTest.evaluate(with: email)
}
