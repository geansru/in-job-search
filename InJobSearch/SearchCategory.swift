//
//  SearchCategory.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

protocol CategoryInterface {
    var title: String { get set }
    var pathComponent: String { get set }
}

class SearchCategory: CategoryBase {
    
    var subcategories: [SearchSubCategory] = []
    
    init(title: String, subcategory: [String]) {
        super.init(title: title)
        if subcategory.isEmpty { return }
        for element in subcategory {
            let subCategory = SearchSubCategory(title: element)
            subcategories.append(subCategory)
        }
    }
    
    init(title: String, subcategory: SearchSubCategory) {
        super.init(title: title)
        self.subcategories = [subcategory]
    }
    
    init(category: SearchCategory) {
        subcategories = category.subcategories
        super.init(title: category.title)
    }
}

class CategoryBase: CategoryInterface {
    var title = ""
    var pathComponent = ""
    
    init(title: String) {
        initialize(title)
    }
    
    func initialize(title: String) {
        self.title = clear(title)
        self.pathComponent = safety(title)
    }
    
    func safety(title: String) ->  String {
        var result = replaceCharacter(title, from: " ", to: "+")
        result = replaceCharacter(result, from: ",", to: "%2C")
        result = replaceCharacter(result, from: "&", to: "%26")
        
        return result
    }
    
    func clear(title: String) ->  String {
        // example: Web%2C+Mobile+%26+Software+Dev -> Web, Mobile & Software Dev
        var result = replaceCharacter(title, from: "+", to: " ")
        result = replaceCharacter(result, from: "%2C", to: ",")
        result = replaceCharacter(result, from: "%26", to: "&")
//        let split_result1 = title.componentsSeparatedByString("+")
//        result = " ".join(split_result1)
//        let split_result2 = title.componentsSeparatedByString("%2C")
//        result = ",".join(split_result2)
        
        return result
    }
    
    func replaceCharacter(sourse: String, from: String, to: String) -> String {
        var result = sourse
        let split_result = result.componentsSeparatedByString(from)
        result = to.join(split_result)
        return result
    }
}