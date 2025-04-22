//
//  PhoneBook+CoreDataProperties.swift
//  spPokeNumberBook
//
//  Created by Lee on 4/22/25.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var image: Data?

}

extension PhoneBook : Identifiable {

}
