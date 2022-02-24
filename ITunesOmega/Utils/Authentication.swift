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
    private var container: NSPersistentContainer {
        // swiftlint:disable force_cast
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        // swiftlint:enable force_cast
    }

    private(set) var currentUser: User?

    private init() {

    }

    func createUser(name: String, surname: String, age: Date, phone: String, email: String, password: String) -> Bool {
        let newUser = User(context: container.viewContext)
        newUser.name = name
        newUser.surname = surname
        newUser.age = age
        newUser.phone = phone
        newUser.email = email.lowercased()
        newUser.password = password

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

    func signIn(email: String, password: String) -> Bool {
        let request = User.createFetchRequest()
        let predicate = NSPredicate(format: "email == %@ AND password == %@", email.lowercased(), password)
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
