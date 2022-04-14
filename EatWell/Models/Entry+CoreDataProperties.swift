//
//  Entry+CoreDataProperties.swift
//  EatWell
//
//  Created by Grant Davis on 4/13/22.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var calories: String?
    @NSManaged public var date: Date?
    @NSManaged public var notes: String?
    @NSManaged public var stringDate: String?

}

extension Entry : Identifiable {

}
