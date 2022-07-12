//
//  CategoryViewParam.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation

class CategoryViewParam: Equatable {
    var isSelected = false
    private (set) var name = ""
    
    init(name: String) {
        self.name = name
    }
    
    static func addDefault() -> CategoryViewParam {
        let category = CategoryViewParam(name: "General")
        category.isSelected = true
        
        return category
    }
    
    static func == (lhs: CategoryViewParam, rhs: CategoryViewParam) -> Bool {
        return lhs.isSelected == rhs.isSelected && lhs.name == rhs.name
    }
}
