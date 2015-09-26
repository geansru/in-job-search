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

protocol Parseable {
    var data: NSData! { get set }
    var dataType:DataType { get set }
}

class Parser {
    
}