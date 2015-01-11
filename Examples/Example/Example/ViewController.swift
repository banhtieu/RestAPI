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

// model for the current track
class CurrentTrackResponse: SerializableModel {
    var CallBackDelay = 0
    var Station = StationData()
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
        
        restAPI.post("/Player/GetCurrentTrack", params: params) {
            (response: CurrentTrackResponse) in
            println("Result: \(response.Station.CurrentTrack)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

