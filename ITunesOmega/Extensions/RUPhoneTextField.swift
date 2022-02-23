//
//  RUPhoneTextField.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 23.02.2022.
//

import Foundation
import PhoneNumberKit

class RUPhoneTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "RU"
        }
        set {} // exists for backward compatibility
    }
}
