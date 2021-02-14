//
//  Model.swift
//  lrn
//
//  Created by Twinbit Limited on 14/2/21.
//

import Foundation


class Section{
    var collapsed: Bool?
    var numberOfItems: Int?
    init(collapsed: Bool?, numberOfItems: Int?) {
        self.collapsed = collapsed
        self.numberOfItems = numberOfItems
    }
    
}
