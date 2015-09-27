//
//  BookmarksViewController.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 27.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

protocol BookmarksViewControllerDelegate {
    func bookmarksViewControllerDidFinish(controller: BookmarksViewController, searchCategories: [SearchCategory])
    func bookmarksViewControllerDidCancel(controller: BookmarksViewController)
}

class BookmarksViewController: UITableViewController {
    
    // MARK: - IBAction
    @IBAction func done() {
        refreshSelectedBookmarksList()
        delegate?.bookmarksViewControllerDidFinish(self, searchCategories: searchCategories)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel() {
        delegate?.bookmarksViewControllerDidCancel(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Properties
    var delegate: BookmarksViewControllerDelegate!
    
    lazy var searchCategories: [SearchCategory] = {
        return Seed.importJSONSeedData()
        }()
    
    var selectedSearchCategories: [SearchCategory] = [SearchCategory] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshSelectedBookmarksList()
        tableView.rowHeight = 64
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchCategories[section].title
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchCategories.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCategories[section].subcategories.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        let object = searchCategories[indexPath.section]
        cell.textLabel!.text = object.subcategories[indexPath.row].title
        cell.detailTextLabel?.text = "Category: " + object.title
        
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
        refreshSelectedBookmarksList()
    }
    
    
}

extension BookmarksViewController {
    // MARK: - Helpers
    func refreshSelectedBookmarksList() {
        for cat in searchCategories {
            for sub in cat.subcategories {
                if sub.selected {
                    let selected = SearchCategory(title: cat.title, subcategory: sub)
                    selectedSearchCategories.append( selected )
                }
            }
        }
    }
}