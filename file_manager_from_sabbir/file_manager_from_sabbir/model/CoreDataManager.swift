//
//  CoreDataSupport.swift
//  Ringtone
//
//  Created by Twinbit Sabuj on 19/1/20.
//  Copyright © 2020 Twinbit. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
        
    init(){}
    
    class func insertData(name: String, path: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Folder", into: context) as! Folder
        
        entity.folder_name = name
        entity.folder_path = path
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Failed saving")
        }
    }
    
    class func updateData(){
        
    }
    
    class func deleteData(withIndex index:Int){
        
       
    }
    
    
    class func fetchData() -> [Folder]{
        
        var listArray = [Folder]()
        
        let request : NSFetchRequest <Folder>  = Folder.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext
                do{
                    listArray = try context.fetch(request)
                    return listArray
                }
                catch{
                    print("Error loading data \(error)")
                }
       
        return listArray

    }
    
}
