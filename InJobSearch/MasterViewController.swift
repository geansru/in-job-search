//
//  MasterViewController.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    lazy var searchCategories: [SearchCategory] = {
        return Seed.importJSONSeedData()
    }()

    var jobs = [Job]()
    var entity: SearchEntity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        entity = SearchEntity(sourse: SourseOfSearch.UpWork(categories: searchCategories))
        let downloader = Downloader(object: entity, delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = searchCategories[indexPath.section]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchCategories.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCategories[section].subcategories.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = searchCategories[indexPath.section]
        cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
//            objects.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

extension MasterViewController: ParserDelegate {
    func parseWillStart(parse: Parser) {
        println(__FUNCTION__)
    }
    func parseDidStart(parse: Parser){
        println(__FUNCTION__)
    }
    func parseDidReceiveError(parse: Parser, errorString: String){
        println(__FUNCTION__)
    }
    func parseWillFinish(parse: Parser){
        println(__FUNCTION__)
    }
    func parseDidFinish(parse: Parser, result: [AnyObject]!){
        println(__FUNCTION__)
    }

}

extension MasterViewController: DownloaderDelegate {
    func downloadWillStart(downloader: Downloader) {
        println(__FUNCTION__)
    }
    func downloadDidStart(downloader: Downloader) {
        println(__FUNCTION__)
    }
    func downloadDidReceiveError(downloader: Downloader, error: NSError) {
        println(__FUNCTION__)
    }
    func downloadWillFinish(downloader: Downloader, response: NSHTTPURLResponse) {
        println(__FUNCTION__)
    }
    func downloadDidFinish(downloader: Downloader, result: [AnyObject]!) {
        println(__FUNCTION__)
        if let aux = result as? [NSData] {
            if let data = aux.first {
                entity.data = data
                let parser = Parser(object: entity, delegate: self)
            }
        }
    }
}