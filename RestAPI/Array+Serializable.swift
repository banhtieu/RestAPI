//
//  Array+Serializable.swift
//  RestAPI
//
//  Created by Tran Thien Khiem on 1/11/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

// Interface for class that can be initialize from
// an input data
protocol SerializableContainer {
    
    // must have input
    init?(data: AnyObject?)
    
    // parse data to this object
    mutating func parse(data: AnyObject?) -> Bool
    
}

// extend array to implement Serializable Protocol
extension Array: SerializableContainer {
    
    // initialize data
    init?(data: AnyObject?) {
        self.init()
        
        // if fail to parse the data
        if !self.parse(data) {
            return nil
        }
    }
    
    // parse the data
    mutating func parse(data: AnyObject?) -> Bool {
        var success = false
        
        if let dataArray = data as? [AnyObject] {
            for item in dataArray {
                var elementType = Element.self
                var modelType = elementType as SerializableModel.Type
                var item = modelType(data: item)
                self.append(item as Element)
            }
        }
        return false
    }
    
}