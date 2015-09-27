//
//  MasterViewController.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    
    // MARK: - Properties
    var detailViewController: DetailViewController? = nil
    var searchCategories = [SearchCategory]()

    var jobs = [Job]()
    var entity: SearchEntity!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()

//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = jobs[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = jobs[indexPath.row]
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

extension MasterViewController {
    // MARK: - helper
    func refresh() {
        if searchCategories.isEmpty { return }
        entity = SearchEntity(sourse: SourseOfSearch.UpWork(categories: searchCategories))
        let downloader = Downloader(object: entity, delegate: self)
    }
}


extension MasterViewController: ParserDelegate {
    func parseWillStart(parse: Parser) {
        Log.m(__FUNCTION__)
    }
    func parseDidStart(parse: Parser){
        Log.m(__FUNCTION__)
    }
    func parseDidReceiveError(parse: Parser, errorString: String){
        Log.m(__FUNCTION__)
    }
    func parseWillFinish(parse: Parser){
        Log.m(__FUNCTION__)
    }
    func parseDidFinish(parse: Parser, result: [AnyObject]!){
        Log.m(__FUNCTION__)
        if let aux = result as? [Job] {
            Log.m("result is type of [Job]")
            jobs = aux
            tableView.reloadData()
        }
    }

}

extension MasterViewController: DownloaderDelegate {
    func downloadWillStart(downloader: Downloader) {
        Log.m(__FUNCTION__)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    func downloadDidStart(downloader: Downloader) {
        Log.m(__FUNCTION__)
    }
    func downloadDidReceiveError(downloader: Downloader, error: NSError) {
        Log.m(__FUNCTION__)
        Log.e(error)
    }
    func downloadWillFinish(downloader: Downloader, response: NSHTTPURLResponse) {
        Log.m(__FUNCTION__)
    }
    func downloadDidFinish(downloader: Downloader, result: [AnyObject]!) {
        Log.m(__FUNCTION__)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if let aux = result as? [NSData] {
            if let data = aux.first {
                entity.data = data
                let parser = Parser(object: entity, delegate: self)
            }
        }
    }
}