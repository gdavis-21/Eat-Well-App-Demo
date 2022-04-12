//
//  Day+CoreDataProperties.swift
//  EatWell
//
//  Created by Grant Davis on 4/12/22.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var day: Int64
    @NSManaged public var hasA: NSSet?

}

// MARK: Generated accessors for hasA
extension Day {

    @objc(addHasAObject:)
    @NSManaged public func addToHasA(_ value: Entry)

    @objc(removeHasAObject:)
    @NSManaged public func removeFromHasA(_ value: Entry)

    @objc(addHasA:)
    @NSManaged public func addToHasA(_ values: NSSet)

    @objc(removeHasA:)
    @NSManaged public func removeFromHasA(_ values: NSSet)

}

extension Day : Identifiable {

}
