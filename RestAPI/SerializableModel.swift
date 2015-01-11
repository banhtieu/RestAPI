//
//  Model.swift
//  Framework
//
//  Created by Tran Thien Khiem on 1/8/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

//
// Model class - base class for all entities
// Automatically parse data from json object
//
public class SerializableModel: NSObject, Serializable {
    
    // intialize 
    public override init() {
        
    }
    
    // override the initialization
    public required init? (data: AnyObject?) {
        super.init()
        parse(data)
    }
    
    // parse data from an Object
    public func parse(data: AnyObject?) -> Bool {
        
        // parse successful
        var success = false
        
        // parse object
        if let dictionary = data as? [String:AnyObject] {
            
            // successful initialize
            success = true
            
            // get type information
            var typeInfo = reflect(self)
            
            // iterate all field
            for var i = 0; i < typeInfo.count; i++ {
                
                // get field name and value
                var (fieldName, fieldInfo) = typeInfo[i]
                
                // there is value
                if let fieldValue: AnyObject = dictionary[fieldName] {
                    
                    var disposition = fieldInfo.disposition
                    
                    if disposition == MirrorDisposition.Aggregate {
                        // normal value
                        self.setValue(fieldValue, forKey: fieldName);
                        
                    } else if disposition == MirrorDisposition.Class {
                        
                        // value is inherited from Model then
                        if let model = fieldInfo.value as? SerializableModel {
                            model.parse(fieldValue)
                            self.setValue(model, forKey: fieldName)
                        } else {
                            println("Cannot downcast to Model")
                        }
                    } else if disposition == MirrorDisposition.IndexContainer {
                        if var model = fieldInfo.value as? Array<AnyObject> {
                            model.parse(fieldValue)
                            self.setValue(model, forKey: fieldName)
                        } else {
                            println("Cannot set array")
                        }
                    }
                }
            }
        }
        
        return success
        
    }
    
    // parse data as List
    public func parseAsList<T: Serializable>(data: AnyObject?) -> [T] {
        return SerializableModel.parseAsList(data)
    }
    
    // parse as list
    public func parseAsList<T>(data: AnyObject?) -> [T] {
        //
        var result = [T]()
        
        if let arrayData = data as? [AnyObject] {
            for item in arrayData {
                result.append(item as T)
            }
        }
        
        return result
    }
    
    // parse Object as Serializable
    public class func parseObject<T: Serializable>(data: AnyObject?) -> T? {
        var result = T(data: data)
        return result
    }
    
    // parse as List
    public class func parseAsList<T: Serializable>(data: AnyObject?) -> [T] {
        var result = [T]()
        
        if let arrayData = data as? [AnyObject] {
            for item in arrayData {
                if var element = T(data: item) {
                    result.append(element)
                }
            }
        }
        
        return result
    }
}
