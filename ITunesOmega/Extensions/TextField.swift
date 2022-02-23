//
//  TextField.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 23.02.2022.
//

import Foundation
import UIKit

extension UITextField {
    var doneToolbar: UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()

        return doneToolbar
    }

    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
