//
//  Vault+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Rozario on 12/11/17.
//  Copyright © 2017 VisionReached. All rights reserved.
//
//

import Foundation
import CoreData


extension Vault {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vault> {
        return NSFetchRequest<Vault>(entityName: "Vault")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var members: NSSet?

}

// MARK: Generated accessors for members
extension Vault {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: User)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: User)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}
