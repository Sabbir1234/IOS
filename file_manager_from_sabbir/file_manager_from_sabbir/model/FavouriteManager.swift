//
//  FavouriteManager.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 16/11/20.
//

import Foundation
import  UIKit
import CoreData

class FavouriteManager{
    
    static let shared = FavouriteManager()
        
    init(){}
    
    class func insertData(folder_name: String, image_name: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Favourite", into: context) as! Favourite
        
        entity.folder_name = folder_name
        entity.image_name = image_name
        
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
        let list = FavouriteManager.fetchData()
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
    
    
    class func fetchData() -> [Favourite]{
        
        var listArray = [Favourite]()
        
        let request : NSFetchRequest <Favourite>  = Favourite.fetchRequest()
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
