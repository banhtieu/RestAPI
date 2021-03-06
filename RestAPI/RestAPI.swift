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
    
    // serialize request using json
    public var serializeRequestByJSON = true
    
    // initializing the Rest API
    public required override init() {
        var settings: RestAPISetting = Factory.get()
        endPoint = settings.endPoint
        
        var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = settings.headers
        session = NSURLSession(configuration: sessionConfiguration)
        
        super.init()
    }
    
    /// Send a GET request to the specified path
    ///
    /// :param: path - The relative path from the root URL
    /// :param: handler - the handle function that receive an object as parameter
    public func get<T: Serializable>(path: String, handler: ((T) -> Void)?) {
        request("GET", path: path, pathParams: nil, postBody: nil, handler: handler)
    }
    
    /// Send a GET request to the specified path
    ///
    /// :param: path - The relative path from the root URL
    /// :param: params - the parameters that passed to the request - will be serialized as parameters in url
    /// :param: handler - the handle function that receive an object as parameter
    ///
    public func get<T: Serializable>(path: String, params: [String: AnyObject]?, handler: ((T) -> Void)?) {
        request("GET", path: path, pathParams: params, postBody: nil, handler: handler)
    }
    
    ///
    /// Send a POST request to the target path
    ///
    /// :param: path - The relative path from the root URL
    /// :param: handler - the handle function that receive an object as parameter
    ///
    public func post<T: Serializable>(path: String, handler: ((T) -> Void)?) {
        request("POST", path: path, pathParams: nil, postBody: nil, handler: handler)
    }
    
    /// Send a POST request to the target path
    ///
    /// :param: path - The relative path from the root URL
    /// :param: params - the parameters that passed to the request - will be serialized as POST parameters
    /// :param: handler - the handle function that receive an object as parameter
    public func post<T: Serializable>(path: String, params: AnyObject?, handler: ((T) -> Void)?) {
        request("POST", path: path, pathParams: params as? [String: AnyObject], postBody: params, handler: handler)
    }
    
    /// Send a GET request to the specified path and get back a list
    ///
    /// :param: path - The relative path from the root URL
    /// :param: handler - the handle function that receive an object as parameter
    public func getAsList<T: Serializable>(path: String, handler: (([T]) -> Void)?) {
        requestAsList("GET", path: path, pathParams: nil, postBody: nil, handler: handler)
    }
    
    /// Send a GET request to the specified path
    ///
    /// :param: path - The relative path from the root URL
    /// :param: params - the parameters that passed to the request - will be serialized as parameters in url
    /// :param: handler - the handle function that receive an object as parameter
    public func getAsList<T: Serializable>(path: String, params: [String: AnyObject]?, handler: (([T]) -> Void)?) {
        requestAsList("GET", path: path, pathParams: params, postBody: nil, handler: handler)
    }
    
    /// Send a POST request to the target path and get a list of objects as response
    ///
    /// :param: path - The relative path from the root URL
    /// :param: handler - the handle function that receive an object as parameter
    public func postAsList<T: Serializable>(path: String, handler: (([T]) -> Void)?) {
        requestAsList("POST", path: path, pathParams: nil, postBody: nil, handler: handler)
    }
    
    /// Send a POST request to the target path and get a list of objects as response
    ///
    /// :param: path - The relative path from the root URL
    /// :param: params - the parameters that passed to the request - will be serialized as POST parameters
    /// :param: handler - the handle function that receive an object as parameter
    public func postAsList<T: Serializable>(path: String, params: AnyObject?, handler: (([T]) -> Void)?) {
        requestAsList("POST", path: path, pathParams: params as? [String: AnyObject], postBody: params, handler: handler)
    }
    
    
    /// Send a request to the target path and get an Object as response
    ///
    /// :param: method - the HTTP Method of the request
    /// :param: path - The relative path from the root URL
    /// :param: pathParams - the parameters that passed to the request - will be serialized as URL parameters
    /// :param: postBody - the parameters that passed to the request - will be serialized as POST Body
    /// :param: handler - the handle function that receive an object as parameter
    func request<T: Serializable>(method: String,
        path: String,
        pathParams: [String: AnyObject]?,
        postBody: AnyObject?,
        handler: ((T) -> Void)?) {
            
            requestAsJSON(method, path: path, pathParams: pathParams, postBody: postBody) {
                dataObject in
                // parse data to desired type
                if var result:T = self.parseData(dataObject) {
                    // call handler
                    if let handlerFunc = handler {
                        handlerFunc(result)
                    }
                } else {
                    println("Parse Data Failed")
                }
            }
            

    }

    /// Send a request to the target path and get a list of objects as response
    ///
    /// :param: method - the HTTP Method of the request
    /// :param: path - The relative path from the root URL
    /// :param: pathParams - the parameters that passed to the request - will be serialized as URL parameters
    /// :param: postBody - the parameters that passed to the request - will be serialized as POST Body
    /// :param: handler - the handle function that receive an object as parameter
    func requestAsList<T: Serializable>(method: String,
        path: String,
        pathParams: [String: AnyObject]?,
        postBody: AnyObject?,
        handler: (([T]) -> Void)?) {
        
        requestAsJSON(method, path: path, pathParams: pathParams, postBody: postBody) {
            dataObject in
            // parse data to desired type
            var result:[T] = SerializableModel.parseAsList(dataObject)
            
            // call handler
            if let handlerFunc = handler {
                handlerFunc(result)
            }
        }
    }
    
    /// Send a request to the target path and get a JSON Object as response
    ///
    /// :param: method - the HTTP Method of the request
    /// :param: path - The relative path from the root URL
    /// :param: pathParams - the parameters that passed to the request - will be serialized as URL parameters
    /// :param: postBody - the parameters that passed to the request - will be serialized as POST Body
    /// :param: handler - the handle function that receive an object as parameter
    func requestAsJSON(
        method: String,
        path: String,
        pathParams: [String: AnyObject]?,
        postBody: AnyObject?,
        callBack: (AnyObject -> Void)){
        
        var url = "\(endPoint)\(path)"
            
        // execute request
        request(method, url: url, pathParams: pathParams, postBody: postBody) {
            (data) in
            
            var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
            
            // there is responded data
            if let dataObject: AnyObject = jsonObject {
                
                callBack(dataObject)
                
            } else {
                println("Result is nil / unrecognize format")
                
                var dataAsString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println("Result: \(dataAsString)")
            }
        }
    }
    
    
    /// Send a request to the target path and get a Data as Response
    ///
    /// :param: method - the HTTP Method of the request
    /// :param: url - The absolute url
    /// :param: pathParams - the parameters that passed to the request - will be serialized as URL parameters
    /// :param: postBody - the parameters that passed to the request - will be serialized as POST Body
    /// :param: handler - the handle function that receive an object as parameter
    func request(method: String,
            url: String,
            pathParams: [String: AnyObject]?,
            postBody: AnyObject?,
            callBack: (NSData -> Void)) {
                
        var request = serializeRequest(method, url: url, pathParams: pathParams, postBody: postBody)
                
        var sessionDataTask = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if error != nil {
                println("There is \(error)")
            } else {
                callBack(data)
            }
        }
        
        sessionDataTask.resume()
    }
    
    // serialize all request data into NSURL Request
    func serializeRequest(method: String, url: String, pathParams: [String: AnyObject]?, postBody: AnyObject?) -> NSURLRequest {
        var fullPath = url
        
        var requestParams = ""
        
        // the request
        if let paramsDictionary = pathParams {
            // params
            for (key, value) in paramsDictionary {
                var valueString = "\(value)"
                requestParams += "\(key)=" + valueString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            }
        }
        
        // if request params =
        if method == "GET" {
            fullPath += "?" + requestParams
        }
        
        var request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
        
        request.HTTPMethod = method
        
        // set header for the request
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if serializeRequestByJSON {
            if let body: AnyObject = postBody {
                if let bodyAsJson = NSJSONSerialization.dataWithJSONObject(body,
                    options: NSJSONWritingOptions.allZeros, error: nil) {
                        
                        request.HTTPBody = bodyAsJson
                        
                        var string = NSString(data: bodyAsJson, encoding: NSUTF8StringEncoding)!
                        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                }
            }
        } else {
            request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = requestParams.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        
        return request
    }

    // parse data as a Serializable Object
    func parseData<T: Serializable>(data: AnyObject) -> T? {
        var result = T(data: data)
        return result
    }
    
    
    
}
