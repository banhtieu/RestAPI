//
//  ViewController.swift
//  Example
//
//  Created by Tran Thien Khiem on 1/11/15.
//  Copyright (c) 2015 Tran Thien Khiem. All rights reserved.
//

import UIKit
import RestAPI

// Station Data Model
class StationData: SerializableModel {
    var ID = 0
    var Name = ""
    var Format = ""
    var BitRate = 0
    var Genre = ""
    var CurrentTrack = ""
}

class ViewController: UIViewController {

    // get the rest api
    var restAPI: RestAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create the restAPI setting
        var restAPISettings = RestAPISetting(endPoint: "http://shoutcast.com")
        
        // get the factory
        restAPI = Factory.get()
        
        var params = ["stationID": 99183933]
        
        restAPI.post("/Home/GetRandomStation") {
            (response: StationData) in
            println("Result: \(response.CurrentTrack)")
        }
        
        restAPI.post("/Home/Top") {
            (response: [StationData])
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

