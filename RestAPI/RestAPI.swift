//
//  RestAPI.swift
//  Framework
//
//  Created by Tran Thien Khiem on 1/9/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit

// Rest API Client
public class RestAPI: NSObject {
    
    // API end point
    public var endPoint: String
    
    // the URLSession
    private var session: NSURLSession
    
    // headers for this request
    private var headers = [String: String]()
    
    // initializing the Rest API
    public required override init() {
        var settings: RestAPISetting = Factory.get()
        endPoint = settings.endPoint
        
        var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = settings.headers
        session = NSURLSession(configuration: sessionConfiguration)
        
        super.init()
    }
    
    // get the object at path
    public func get<T: Serializable>(path: String, handler: ((T) -> Void)?) {
        request("GET", path: path, pathParams: nil, postBody: nil, handler: handler)
    }
    
    // request with a little params
    public func get<T: Serializable>(path: String, params: [String: AnyObject]?, handler: ((T) -> Void)?) {
        request("GET", path: path, pathParams: params, postBody: nil, handler: handler)
    }
    
    // post with no params
    public func post<T: Serializable>(path: String, handler: ((T) -> Void)?) {
        request("POST", path: path, pathParams: nil, postBody: nil, handler: handler)
    }
    
    // post with params
    public func post<T: Serializable>(path: String, params: AnyObject?, handler: ((T) -> Void)?) {
        request("POST", path: path, pathParams: nil, postBody: params, handler: handler)
    }
    
    // call a request
    func request<T: Serializable>(method: String,
        path: String,
        pathParams: [String: AnyObject]?,
        postBody: AnyObject?,
        handler: ((T) -> Void)?) {
            var fullPath = "\(endPoint)\(path)?"
            
            // the request
            if let paramsDictionary = pathParams {
                // params
                for (key, value) in paramsDictionary {
                    var valueString = "\(value)"
                    fullPath += "\(key)=" + valueString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                }
            }
            
            var request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
            
            request.HTTPMethod = method
            
            // set header for the request
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            if let body: AnyObject = postBody {
                if let bodyAsJson = NSJSONSerialization.dataWithJSONObject(body,
                    options: NSJSONWritingOptions.allZeros, error: nil) {
                        
                        request.HTTPBody = bodyAsJson
                        
                        var string = NSString(data: bodyAsJson, encoding: NSUTF8StringEncoding)!
                        println("Request: \(fullPath)")
                        println("Body: \(string)")
                        println("Size: \(bodyAsJson.length)")
                }
            }
            
            // create a data task
            var sessionDataTask = session.dataTaskWithRequest(request) {
                (data, response, error) in
                
                // there is an error
                if error != nil {
                    print("There is \(error)")
                } else {
                    // there is no error
                    var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
                    
                    // there is responded data
                    if let dataObject: AnyObject = jsonObject {
                        
                        // parse data to desired type
                        if var result:T = self.parseData(dataObject) {
                            // call handler
                            if let handlerFunc = handler {
                                handlerFunc(result)
                            }
                        } else {
                            println("Parse Data Failed")
                        }
                        
                    } else {
                        println("Result is nil / unrecognize format")
                        
                        var dataAsString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                        println("Result: \(dataAsString)")
                    }
                }
            }
            
            sessionDataTask.resume()
    }
    
    // parse data as a Serializable Object
    func parseData<T: Serializable>(data: AnyObject) -> T? {
        var result = T(data: data)
        return result
    }
    
    
    
}
