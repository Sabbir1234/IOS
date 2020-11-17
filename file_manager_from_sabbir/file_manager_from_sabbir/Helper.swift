//
//  Helper.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 17/11/20.
//

import Foundation

class Helper{
    
    func getUniqueName() -> String
    {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let fileName = "\(year)-\(month)-\(day)-\(hour)-\(minutes)-\(seconds).jpg"
        
        return fileName
        
    }
    
    
}
