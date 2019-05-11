//
//  Title+CoreDataProperties.swift
//  Assignment1
//
//  Created by lau tszchung on 9/11/2018.
//  Copyright © 2018 lau tszchung. All rights reserved.
//
//

import Foundation
import CoreData


extension Title {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Title> {
        return NSFetchRequest<Title>(entityName: "Title")
    }

    @NSManaged public var title: String?

}
