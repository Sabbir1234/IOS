//
//  Category.swift
//  music_library
//
//  Created by Twinbit LTD on 24/11/20.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Codable {
    let name: String
    let subcategories: [Subcategory]
}

// MARK: - Subcategory
struct Subcategory: Codable {
    let name: String
}
