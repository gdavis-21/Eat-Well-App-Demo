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

}

extension Day : Identifiable {

}
