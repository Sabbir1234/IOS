//
//  Favourite+CoreDataProperties.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 16/11/20.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var folder_name: String?
    @NSManaged public var image_name: String?

}

extension Favourite : Identifiable {

}
