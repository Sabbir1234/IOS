//
//  ImageDBManager.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 17/11/20.
//

import Foundation
import  UIKit
import CoreData

class ImageDBManager{
    
    static let shared = ImageDBManager()
    
    init(){}
    
    class func insertData(folder_name: String, image_name: String , icon_name: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "ImageDB", into: context) as! ImageDB
        
        entity.folder_name = folder_name
        entity.image_name = image_name
        entity.icon_name = icon_name
        
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
        let list = ImageDBManager.fetchData()
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
    
    class func deleteFoldersImage(folder_name : String){
        //var listArray = [ImageDB]()
        
        //let request : NSFetchRequest <ImageDB>  = ImageDB.fetchRequest()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageDB")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let pred = NSPredicate(format: "folder_name CONTAINS %@", folder_name)
        
        fetchRequest.predicate = pred
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete all data. \(error), \(error.userInfo)")
            
            
            
            
        }
    }
    
    class func fetchData() -> [ImageDB]{
        
        var listArray = [ImageDB]()
        
        let request : NSFetchRequest <ImageDB>  = ImageDB.fetchRequest()
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
    
    class func fetchFolderImage(folder_name: String) -> [ImageDB]{
        
        var listArray = [ImageDB]()
        
        let request : NSFetchRequest <ImageDB>  = ImageDB.fetchRequest()
        
        let pred = NSPredicate(format: "folder_name CONTAINS %@", folder_name)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
    
    
    class func fetchFavouriteImage(icon_name: String) -> [ImageDB]{
        
        var listArray = [ImageDB]()
        
        let request : NSFetchRequest <ImageDB>  = ImageDB.fetchRequest()
        
        let pred = NSPredicate(format: "icon_name CONTAINS %@", icon_name)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
    
    class func updateIcon(image_name: String) {
        
        let request : NSFetchRequest <ImageDB>  = ImageDB.fetchRequest()
        let pred = NSPredicate(format: "image_name CONTAINS %@", image_name)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        request.predicate = pred
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            if let objectToUpdate = result.first as? NSManagedObject {
                
                if objectToUpdate.value(forKey: "icon_name") as! String == "star_icon"
                {
                    objectToUpdate.setValue("starMark", forKey: "icon_name")
                    
                    try context.save()
                    print("saved sucessfully")
                    
                }
                else
                {
                    objectToUpdate.setValue("star_icon", forKey: "icon_name")
                    
                    try context.save()
                }
                
                
                
                
            }
        }catch{
            print("Error")
        }
        
    }
    
    
    
    
    class func renameFolder(folder_name: String , newName: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let context = appDelegate.persistentContainer.viewContext

        let entity =  NSEntityDescription.entity(forEntityName: "ImageDB", in: context)!
        let updateRequest = NSBatchUpdateRequest(entity: entity)

        // only update persons who have money less than 10000
        // can remove this line if you want to update all persons
        updateRequest.predicate = NSPredicate(format: "folder_name = %@", folder_name)

        // update the money to 10000, can add more attribute name and value to the hash if you want
        updateRequest.propertiesToUpdate = ["folder_name" : newName]

        // return the number of updated objects for the result
        updateRequest.resultType = .updatedObjectsCountResultType

        do {
          let result = try context.execute(updateRequest) as! NSBatchUpdateResult
          print("\(result.result ?? 0) objects updated")
          
        } catch let error as NSError {
          print("Could not batch update. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    
}
