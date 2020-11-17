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
    
    class func updateData(folder_name: String ,name : String ){
        
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let context = appDelegate.persistentContainer.viewContext
       
        let request : NSFetchRequest <Folder>  = Folder.fetchRequest()
        
        let pred = NSPredicate(format: "folder_name CONTAINS %@", folder_name)
        
        request.predicate = pred
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            if let objectToUpdate = result.first as? NSManagedObject {
                
                if objectToUpdate.value(forKey: "folder_name") as! String == folder_name
                {
                    objectToUpdate.setValue(name, forKey: "folder_name")
                    
                    try context.save()
                    print("saved sucessfully")
                    
                }
                else
                {
                    print("Unsuccessful")
                    
                    try context.save()
                }
                
                
                
                
            }
        }catch{
            print("Error")
        }
        
    }
    
    class func deleteData(withIndex index:Int){
        let list = CoreDataManager.fetchData()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let context = appDelegate.persistentContainer.viewContext
        print("context")
        print(index)
                context.delete(list[index])
                do {
                    try context.save()
                    print("Saved in core Data")
                } catch {
                    print("Failed saving")
                }
       
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
    
    class func fetchDataWithSameName(name : String) -> [Folder]{
        
        var listArray = [Folder]()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let request : NSFetchRequest <Folder>  = Folder.fetchRequest()
        
        let pred = NSPredicate(format: "folder_name CONTAINS %@", name)
        
        request.predicate = pred

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
