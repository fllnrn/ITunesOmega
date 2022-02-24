//
//  SignUpViewController.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 22.02.2022.
//

import UIKit
import PhoneNumberKit

class SignUpViewController: UIViewController {
    enum Constants {
        static let minAgeDateTime = Date(timeIntervalSinceNow: -18*365*24*60*60)
        static let maxAgeDateTime = Date(timeIntervalSinceNow: -100*365*24*60*60)
    }

    private let name = UITextField()
    private let surname = UITextField()
    private let ageLbl = UILabel()
    private let age = UIDatePicker()
    private let phone = RUPhoneTextField()
    private let email = UITextField()
    private let password = UITextField()
    private let signUpBtn = UIButton(type: .roundedRect)
    private let scroll = UIScrollView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        signUpBtn.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardHandler), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupUI()
        layoutUI()
    }

    private func configure(textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.inputAccessoryView = textField.doneToolbar
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }

    private func setupUI() {
        configure(textField: name)
        name.placeholder = NSLocalizedString("Name", comment: "Name")
        name.keyboardType = .asciiCapable

        configure(textField: surname)
        surname.placeholder = NSLocalizedString("Surname", comment: "Surname")
        surname.keyboardType = .asciiCapable

        ageLbl.text = NSLocalizedString("Birth Date", comment: "Birth Date")
        age.datePickerMode = .date
        age.date = Constants.minAgeDateTime
        age.maximumDate = Constants.minAgeDateTime
        age.minimumDate = Constants.maxAgeDateTime
        age.preferredDatePickerStyle = .compact

        phone.borderStyle = .roundedRect
        phone.withExamplePlaceholder = true
        phone.withPrefix = true // международный формат +7 ХХХ ХХХ-ХХ-ХХ / false - 8 (XXX) XXX XX-XX
        phone.maxDigits = 10
        phone.inputAccessoryView = phone.doneToolbar

        configure(textField: email)
        email.placeholder = NSLocalizedString("Email", comment: "Email")
        email.textContentType = .emailAddress
        email.keyboardType = .emailAddress

        configure(textField: password)
        password.placeholder = NSLocalizedString("Password", comment: "Password")
        password.textContentType = .newPassword
        password.isSecureTextEntry = true

        signUpBtn.setTitle(NSLocalizedString("Sign Up", comment: "Sign Up"), for: .normal)
    }

    override func viewDidLayoutSubviews() {
        scroll.contentSize = stackView.frame.size
    }

    private func layoutUI() {
        name.translatesAutoresizingMaskIntoConstraints = false
        surname.translatesAutoresizingMaskIntoConstraints = false
        ageLbl.translatesAutoresizingMaskIntoConstraints = false
        age.translatesAutoresizingMaskIntoConstraints = false
        phone.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(surname)
        stackView.addArrangedSubview(UIStackView(arrangedSubviews: [ageLbl, age]))
        stackView.addArrangedSubview(phone)
        stackView.addArrangedSubview(email)
        stackView.addArrangedSubview(password)
        stackView.addArrangedSubview(signUpBtn)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stackView)
        view.addSubview(scroll)

        let stackConstraints = [
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.spacer),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.spacer)
        ]
        NSLayoutConstraint.activate(stackConstraints)

        let scrollConstraints = [
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            scroll.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(scrollConstraints)
    }

    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }

    func isFormValide() -> Bool {
        guard let name = name.text, name.count > 0 else {
            showErrorAlert(message: NSLocalizedString("Name not filled", comment: ""))
            return false
        }
        guard let surname = surname.text, surname.count > 0 else {
            showErrorAlert(message: NSLocalizedString("Surname not filled", comment: ""))
            return false
        }
        guard phone.isValidNumber else {
            showErrorAlert(message: NSLocalizedString("Phone number not valid", comment: ""))
            return false
        }
        guard isPasswordValid(password.text!) else {
            showErrorAlert(message: NSLocalizedString("Password requirements: at least 6 digits, [0-9, a-z, A-Z]", comment: ""))
            return false
        }
        guard isEmailValid(email.text!) else {
            showErrorAlert(message: NSLocalizedString("Wrong email format", comment: ""))
            return false
        }
        return true
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel))
        present(alert, animated: true)
    }

    @objc func signUpPressed() {
        if isFormValide() {
            let sucess = Authentication.shared.createUser(name: name.text!, surname: surname.text!, age: age.date, phone: phone.text!, email: email.text!, password: password.text!)
            if sucess {
                dismiss(animated: true)
            } else {
                showErrorAlert(message: NSLocalizedString("Error. User was not created", comment: "Error. User was not created"))
            }
        } else {
            print("Sign up pressed. Invalide form")
        }
    }

    @objc func adjustForKeyboardHandler(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardFrame = value.cgRectValue
        var contentInset: UIEdgeInsets!
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case UIResponder.keyboardWillChangeFrameNotification:
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        default:
            break
        }
        scroll.contentInset = contentInset
        scroll.scrollIndicatorInsets = contentInset
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpPressed()
        return true
    }
}
