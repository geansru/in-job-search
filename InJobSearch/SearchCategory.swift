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
        let clear = title.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let safety = title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        self.title = clear ?? title
        self.pathComponent = safety ?? title
    }
}