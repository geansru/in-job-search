//
//  SourseOfSearch.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

enum SourseOfSearch {
    case UpWork(categories: [SearchCategory])
    
//    var entityValue
    func basePath() -> String {
        switch self {
        case .UpWork(_): return "https://www.upwork.com/jobs/rss?"
        }
    }
    
    func path() -> String {
        var base = self.basePath()
        switch self {
        case .UpWork(let categories):
            for (index, category) in enumerate(categories) { base = base + "cn\(index+1)=" + category.pathComponent + "&" }
            base = base + "q=&from=find-work"
            Log.m(base)
            return base
        default: Log.d("SourseOfSearch.\(__FUNCTION__): unknown sourse"); return ""
        }
    }
    
    func url() -> NSURL! {
        switch self {
        case .UpWork(_): return NSURL(string: self.path())
        default: Log.d("SourseOfSearch.\(__FUNCTION__): unknown sourse")
        }
        return nil
    }
}