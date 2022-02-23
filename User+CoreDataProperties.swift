//
//  User+CoreDataProperties.swift
//  ITunesOmega
//
//  Created by Андрей Гавриков on 23.02.2022.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String
    @NSManaged public var surname: String
    @NSManaged public var age: Date
    @NSManaged public var phone: String
    @NSManaged public var email: String

}

extension User: Identifiable {

}
