//
//  Favourite+CoreDataProperties.swift
//  FinalTest_Iurii
//
//  Created by Iurii Kondrakov on 2022-04-15.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var name: String?
    @NSManaged public var population: Int32

}

extension Favourite : Identifiable {

}
