//
//  SubCategory.swift
//  music_library
//
//  Created by Twinbit LTD on 24/11/20.
//

import Foundation

struct  Sleepcategory: Decodable {
    var trackName = ""
    var artistName = ""
    var trackPath = ""
}

struct BottomList : Decodable
{
    var sleepsounds : [Sleepcategory]
    
}
