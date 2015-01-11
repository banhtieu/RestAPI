//
//  RestAPISetting.swift
//  Framework
//
//  Created by Tran Thien Khiem on 1/10/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

// setting
class RestAPISetting: NSObject {
    
    // end point of the request
    let endPoint = "https://ohyeap.com"
    
    // headers of the request
    let headers:[String: String] = [
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json, text/plain, */*",
        "Copyright": "Ohyeap.Com",
        "Content-Type":	"application/json;charset=UTF-8",
        "User-Agent": "OhYeap App",
    ]
}
