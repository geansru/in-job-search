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
        let split_result = title.componentsSeparatedByString(" ")
        var result = "+".join(split_result)
        
        if let aux = result.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            result = aux
        }
        
        return result
    }
    
    func clear(title: String) ->  String {
        // example: Web%2C+Mobile+%26+Software+Dev -> Web, Mobile & Software Dev
        var result = title.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        if let split_result = result?.componentsSeparatedByString("+") {
            result = " ".join(split_result)
        }
        return result!
    }
    
}