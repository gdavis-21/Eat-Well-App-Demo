//
//  Entry+CoreDataProperties.swift
//  EatWell
//
//  Created by Grant Davis on 4/12/22.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var calories: Int64
    @NSManaged public var notes: String?
    @NSManaged public var time: String?
    @NSManaged public var day: Int64

}

extension Entry : Identifiable {

}
