//
//  Factory.swift
//  Framework
//
//  Created by Tran Thien Khiem on 1/4/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

public protocol Initializable {
    init()
}

extension NSObject: Initializable {
    
}

//
// The Factory that stores all objects 
// Usage:
//      var a: Class = Factory.get()
//      => Maintain only 1 instance of Class during execution
//
public class Factory: NSObject {
    
    // Factory data
    private struct FactoryData {
        static var objects = [AnyObject]()
    }
    
    //
    //  Get Object from Factory
    //
    public class func get<T: Initializable>() -> T! {
        
        // the result
        var result:T! = nil
        
        // search for item in factory
        for item in FactoryData.objects {
            
            // if item is T then
            if item is T {
                result = item as T
                break
            }
        }
        
        // instantiate if necessary
        if result == nil {
            result = T()
        }
        
        return result
    }
    
    //
    // Register an object
    //
    public class func register(object:AnyObject) {
        FactoryData.objects.append(object)
    }
}
