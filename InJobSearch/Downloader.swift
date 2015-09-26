//
//  Downloader.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

protocol Downloadable {
    var url: NSURL! { get set }
    var sourse: SourseOfSearch { get set }
    var dataTask: NSURLSessionDataTask! { get set }
}

protocol DownloaderDelegate {
    func downloadWillStart(downloader: Downloader)
    func downloadDidStart(downloader: Downloader)
    func downloadDidReceiveError(downloader: Downloader, error: NSError)
    func downloadWillFinish(downloader: Downloader, response: NSHTTPURLResponse)
    func downloadDidFinish(downloader: Downloader, result: [AnyObject]!)
}

class Downloader {
    var delegate: DownloaderDelegate!
    var object: Downloadable
    
    init(object: Downloadable) {
        self.object = object
    }
    
    convenience init(object: Downloadable, delegate: DownloaderDelegate) {
        self.init(object: object)
        self.delegate = delegate
        execute()
    }
    
    func execute() {
        delegate.downloadWillStart(self)
        let session = NSURLSession.sharedSession()
        if let url = object.url {
            object.dataTask?.cancel()
            object.dataTask = session.dataTaskWithURL(url, completionHandler: {
                (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                self.delegate.downloadWillFinish(self, response: (response as? NSHTTPURLResponse)!)
                if let error = error { self.delegate.downloadDidReceiveError(self, error: error) }
                if let data = data {
                    self.delegate.downloadDidFinish(self, result: [data])
                } else {
                    let mess: String = "NSData object recieving in closure dataTaskWithURL: is nil"
                    Log.m(mess)
                    let info: [NSObject : AnyObject] = ["Explanation": mess, "Function": __FUNCTION__]
                    let error: NSError = NSError(domain: "Downloading error", code: 1, userInfo: info)
                    self.delegate.downloadDidReceiveError(self, error: error)
                }
                
                self.delegate.downloadDidFinish(self, result: nil)
                
            })
            
            object.dataTask.resume()
            delegate.downloadDidStart(self)
        } else {
            let mess: String = "NSURL object recieving from Dowmloadable object is nil"
            Log.m(mess)
            let info: [NSObject : AnyObject] = ["Explanation": mess, "Function": __FUNCTION__]
            let error: NSError = NSError(domain: "Internal eror", code: 1, userInfo: info)
            delegate.downloadDidReceiveError(self, error: error)
            delegate.downloadDidFinish(self, result: nil)
        }
        
    }
}