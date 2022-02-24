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

        // swiftlint:disable unused_setter_value
        set {} // exists for backward compatibility
        // swiftlint:enable unused_setter_value
    }
}
