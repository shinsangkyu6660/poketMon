//
//  Poket+CoreDataProperties.swift
//  Poketmon - project
//
//  Created by 신상규 on 7/17/24.
//
//

import Foundation
import CoreData


extension Poket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poket> {
        return NSFetchRequest<Poket>(entityName: "Poket")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var image: String?

}

extension Poket : Identifiable {

}
