//
//  Serializable.swift
//  RestAPI
//
//  Created by Tran Thien Khiem on 1/11/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

// Interface for class that can be initialize from 
// an input data
public protocol Serializable {
    
    // must have input
    init?(data: AnyObject?)
    
    // parse data to this object
    func parse(data: AnyObject?) -> Bool

}