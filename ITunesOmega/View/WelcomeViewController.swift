//
//  WelcomeViewController.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 21.02.2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    private var email = UITextField()
    private var password = UITextField()
    private var logInBtn = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = "Log out"
        navigationController?.navigationBar.prefersLargeTitles = true
        title = NSLocalizedString("Sign In", comment: "Sign In")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: "Sign Up"), style: .done, target: self, action: #selector(addUserPressed))
        logInBtn.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        setupUI()
        layoutUI()
    }

    private func setupUI() {
        email.placeholder = NSLocalizedString("Email", comment: "Email")
        email.borderStyle = .roundedRect
        password.placeholder = NSLocalizedString("Password", comment: "Password")
        password.borderStyle = .roundedRect
        password.isSecureTextEntry = true
        logInBtn.setTitle(NSLocalizedString("Log In", comment: "Log In"), for: .normal)
    }

    private func layoutUI() {
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        logInBtn.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [email, password, logInBtn])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let stackConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstants.spacer),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstants.spacer)
        ]
        NSLayoutConstraint.activate(stackConstraints)
    }

    @objc func addUserPressed() {
        let signUp = UINavigationController(rootViewController: SignUpViewController())
        present(signUp, animated: true)
    }

    @objc func logInPressed() {
        let albumsVC = AlbumsListViewController(albumsViewModel: AlbumsViewModel())
        show(albumsVC, sender: self)
    }

}
