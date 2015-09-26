//
//  Parser.swift
//  InJobSearch
//
//  Created by Dmitriy Roytman on 26.09.15.
//  Copyright (c) 2015 Dmitriy Roytman. All rights reserved.
//

import Foundation

enum DataType {
    case XML
    case HTML
    case Image
}

protocol ParserDelegate {
    func parseWillStart(parse: Parser)
    func parseDidStart(parse: Parser)
//    func parseDidReceiveError(parse: Parser, error: NSError)
    func parseDidReceiveError(parse: Parser, errorString: String)
    func parseWillFinish(parse: Parser)
    func parseDidFinish(parse: Parser, result: [AnyObject]!)
}

protocol Parseable {
    var data: NSData! { get set }
    var dataType:DataType { get set }
    var sourse: SourseOfSearch { get set }
}

class Parser {
    var object: Parseable
    var delegate: ParserDelegate!
    init(object: Parseable) {
        self.object = object
    }
    
    convenience init(object: Parseable, delegate: ParserDelegate) {
        self.init(object: object)
        self.delegate = delegate
        parse()
    }
    
    func parse() {
        delegate?.parseWillStart(self)
        switch object.sourse {
        case .UpWork(_): parseUpwork()
        }
    }
    
    func parseUpwork() {
        var result = [Job]()
        delegate?.parseDidStart(self)
        Log.m("TODO in \(__FUNCTION__)")
        switch object.dataType {
        case .XML:
            if let data = object.data {
                if let xmlString = NSString(data: data, encoding: NSUTF8StringEncoding){
                    let job = JobUpWork(xmlString: xmlString)
                    result.append(job)
                } else {
                    delegate.parseDidReceiveError(self, errorString: "Cann't process NSdata to NSString in \(__FUNCTION__)")
                }
            } else {
                delegate.parseDidReceiveError(self, errorString: "NSdata object is nil in \(__FUNCTION__)")
            }
            delegate?.parseWillFinish(self)
        default: delegate?.parseDidReceiveError(self, errorString: "Unusable data type: \(object.sourse)")
        }
        delegate?.parseDidFinish(self, result: result)
    }
}