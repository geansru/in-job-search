//
//  Seed.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 27.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

class Seed
{
    static func importJSONSeedData() -> [SearchCategory] {
        var result = [SearchCategory]()
        let jsonURL = NSBundle.mainBundle().URLForResource("seed", withExtension: "json")
        let jsonData = NSData(contentsOfURL: jsonURL!)
        
        var error: NSError? = nil
        let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error) as! NSArray
        
        for jsonDictionary in jsonArray {
            
            let categoryName = jsonDictionary["name"] as! String
            let subs = jsonDictionary["subs"] as! [String]
            
            let team = SearchCategory(title: categoryName, subcategory: subs)
            
        }
        
        println("Imported \(jsonArray.count) teams")
        return result
    }

}