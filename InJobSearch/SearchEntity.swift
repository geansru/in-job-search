//
//  SearchEntity.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

class SearchEntity: Downloadable, Parseable {
    // MARK: - Downloadable deleagate
    var url: NSURL!
    var sourse: SourseOfSearch
    var dataTask: NSURLSessionDataTask!
    
    // MARK: - Properties
    var categories: [SearchCategory] = []
    
    // MARK: - Parseable deleagate
    var data: NSData!
    var dataType:DataType = .XML
    
    init(sourse: SourseOfSearch) {
        self.sourse = sourse
        switch sourse {
        case .UpWork(let categories):
            self.categories = categories
            self.url = sourse.url()
            Log.m(self.url?.description ?? "\(__FUNCTION__): url is empty")
        }
    }
}