//
//  RestAPISetting.swift
//  Framework
//
//  Created by Tran Thien Khiem on 1/10/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

// setting
public class RestAPISetting: NSObject {
    
    // end point of the request
    public var endPoint:String
    
    // headers of the request
    public var headers:[String: String] = [
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json, text/plain, */*",
    ]

    // initialize with end point
    public init(endPoint: String) {
        self.endPoint = endPoint
        
        super.init()
        
        Factory.register(self)
    }
}
