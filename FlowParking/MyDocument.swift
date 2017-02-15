//
//  MyDocument.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou on 15/02/2017.
//  Copyright © 2017 Pavlos Nicolaou. All rights reserved.
//

import UIKit

class MyDocument: UIDocument {
    
    var userText: String? = "Some Sample Text"
    
    
    override func contents(forType typeName: String) throws -> Any {
        if let content = userText {
            
            let length =
                content.lengthOfBytes(using: String.Encoding.utf8)
            return NSData(bytes:content, length: length)
        } else {
            return Data()
        }
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? Data {
            userText = NSString(bytes: (contents as AnyObject).bytes,
                                length: userContent.count,
                                encoding: String.Encoding.utf8.rawValue) as? String
        }
    } 
}

