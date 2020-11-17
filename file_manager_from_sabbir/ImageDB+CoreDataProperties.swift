//
//  ImageDB+CoreDataProperties.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 17/11/20.
//
//

import Foundation
import CoreData


extension ImageDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDB> {
        return NSFetchRequest<ImageDB>(entityName: "ImageDB")
    }

    @NSManaged public var folder_name: String?
    @NSManaged public var image_name: String?
    @NSManaged public var icon_name: String?

}

extension ImageDB : Identifiable {

}
