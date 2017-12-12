//
//  User+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Rozario on 12/11/17.
//  Copyright © 2017 VisionReached. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32

}
