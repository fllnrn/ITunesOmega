//
//  Authentication.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 24.02.2022.
//

import Foundation
import UIKit
import CoreData

class Authentication {
    static var shared = Authentication()
    static private var salt = 4 // choosen by fair dice roll
    private var container: NSPersistentContainer {
        // swiftlint:disable force_cast
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        // swiftlint:enable force_cast
    }

    private func hashedPassword(_ pass: String) -> Int64 {
        Int64(pass.hashValue + Authentication.salt)
    }

    private(set) var currentUser: User?

    private init() {

    }

    // swiftlint:disable function_parameter_count
    func createUser(name: String, surname: String, age: Date, phone: String, email: String, password: String) -> Bool {
        let newUser = User(context: container.viewContext)
        newUser.name = name
        newUser.surname = surname
        newUser.age = age
        newUser.phone = phone
        newUser.email = email.lowercased()
        newUser.password = hashedPassword(password)

        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error while saving: \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
    // swiftlint:enable function_parameter_count

    func signIn(email: String, password: String) -> Bool {
        let request = User.createFetchRequest()
        let predicate = NSPredicate(format: "email == %@ AND password == %lld", email.lowercased(), hashedPassword(password))

        request.predicate = predicate

        do {
            let users = try self.container.viewContext.fetch(request)
            if users.count > 0 {
                currentUser = users[0]
                return true
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }

    func signOut() {
        currentUser = nil
    }
}
