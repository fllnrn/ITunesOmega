//
//  User+CoreDataProperties.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 24.02.2022.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Date
    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var surname: String
    @NSManaged public var password: String

}

extension User: Identifiable {

}
