//
//  DatabaseHelper.swift
//  Fasting
//
//  Created by Twinbit on 28/7/20.
//  Copyright © 2020 twinbit. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DatabaseHelper    //--- lets say, db-table name is "Contact"
{
    static var shareInstance = DatabaseHelper ()
    //let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let context = AppDelegate.viewContext

    
    func saveContext(errorText:String) {
        do{
            
            try context.save()
            
            print("Saved")
            
            
        }catch{
            print(errorText)
            
        }
    }
    
    private func createUser()->UserInfo{
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context) as! UserInfo
        saveContext(errorText: "can't insert")
        return newUser
    }
    private func getUserObject()->UserInfo{
        var users = [UserInfo]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo")

        do{
            try users = context.fetch(fetchRequest) as! [UserInfo]
        }catch{
            print("cant fetch")
        }
        return users[0]
    }
    
    func getUser()->UserInfo {
        var user: UserInfo
        if UserDefaults.standard.object(forKey: "USER_INFO_CREATED") == nil {
            user = createUser()
            
            print("------------------")
            print("user created")
            
            UserDefaults.standard.set(true, forKey: "USER_INFO_CREATED")
        }
        else {
            user = getUserObject()
            
            print("------------------")
            print("user fetched")
            print(user)
        }
        return user
    }
    func updateUser(){
        saveContext(errorText: "user data updated")
        
    }
    

    
}
