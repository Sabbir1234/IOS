//
//  Folder+CoreDataProperties.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 11/11/20.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var folder_path: String?
    @NSManaged public var folder_name: String?

}

extension Folder : Identifiable {

}
