//
//  Poket+CoreDataClass.swift
//  Poketmon - project
//
//  Created by 신상규 on 7/17/24.
//
//

import Foundation
import CoreData

@objc(Poket)
public class Poket: NSManagedObject {
    public static let className = "Poket"
    public enum Key {
        static let name = "name"
        static let number = "number"
        static let image = "image"
    }
}
