//
//  ResponseData.swift
//  RestAPI
//
//  Created by Tran Thien Khiem on 1/11/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

// call back delay
public class ResponseDataList<T: Serializable>: Serializable {
    
    // data is template
    var data:[T]! = nil
    
    // initialize with provided data
    public required init?(data: AnyObject?) {
        
        // if parse data failed then return false
        if !parse(data) {
            return nil
        }
    }
    
    // parse the data and return if success
    public func parse(data: AnyObject?) -> Bool {
        
        // success is false
        var success = false
        
        // if data is an dictionary
        if let dataDict = data as? [String: AnyObject] {
            self.data = SerializableModel.parseAsList(data)
            success = (self.data != nil)
        }
        
        return success
    }
}
