//
//  SignUpViewController.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 22.02.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    private let name = UITextField()
    private let surname = UITextField()
    private let age = UITextField()
    private let phone = UITextField()
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

    private func setupUI() {
        name.placeholder = NSLocalizedString("Name", comment: "Name")
        name.borderStyle = .roundedRect
        name.delegate = self
        surname.placeholder = NSLocalizedString("Surname", comment: "Surname")
        surname.borderStyle = .roundedRect
        surname.delegate = self
        age.placeholder = NSLocalizedString("Age", comment: "Age")
        age.borderStyle = .roundedRect
        age.delegate = self
        phone.placeholder = NSLocalizedString("Phone number", comment: "Phone number")
        phone.borderStyle = .roundedRect
        phone.delegate = self
        email.placeholder = NSLocalizedString("Email", comment: "Email")
        email.borderStyle = .roundedRect
        email.delegate = self
        password.placeholder = NSLocalizedString("Password", comment: "Password")
        password.borderStyle = .roundedRect
        password.delegate = self
        password.isSecureTextEntry = true
        signUpBtn.setTitle(NSLocalizedString("Sign Up", comment: "Sign Up"), for: .normal)
    }

    override func viewDidLayoutSubviews() {
        scroll.contentSize = stackView.frame.size
    }

    private func layoutUI() {
//        let doneBtn = UIButton(type: .roundedRect)
//        doneBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
//        view.addSubview(doneBtn)
//        doneBtn.translatesAutoresizingMaskIntoConstraints = false
//        let doneLayout = [
//            doneBtn.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            doneBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
//        ]
//        NSLayoutConstraint.activate(doneLayout)

        name.translatesAutoresizingMaskIntoConstraints = false
        surname.translatesAutoresizingMaskIntoConstraints = false
        age.translatesAutoresizingMaskIntoConstraints = false
        phone.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(surname)
        stackView.addArrangedSubview(age)
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
        return false
    }

    @objc func signUpPressed() {
        print("Sign up pressed")
    }

    @objc func adjustForKeyboardHandler(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardFrame = value.cgRectValue
        var contentInset: UIEdgeInsets!
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            contentInset = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        case UIResponder.keyboardWillChangeFrameNotification:
            contentInset = UIEdgeInsets(top: 64.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        default:
            break
        }
        scroll.contentInset = contentInset
        scroll.scrollIndicatorInsets = contentInset
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = isFormValide()
        textField.resignFirstResponder()
        return true
    }
}
