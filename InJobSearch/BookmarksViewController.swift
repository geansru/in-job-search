//
//  BookmarksViewController.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 27.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

class BookmarksViewController: UITableViewController {
    
    lazy var searchCategories: [SearchCategory] = {
        return Seed.importJSONSeedData()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchCategories.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCategories[section].subcategories.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let object = searchCategories[indexPath.section]
        cell.textLabel!.text = object.subcategories[indexPath.row].pathComponent
        
        if searchCategories[indexPath.section].subcategories[indexPath.row].selected {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        searchCategories[indexPath.section].subcategories[indexPath.row].selected =
            !searchCategories[indexPath.section].subcategories[indexPath.row].selected
        if searchCategories[indexPath.section].subcategories[indexPath.row].selected {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    
}