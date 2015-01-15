# RestAPI
A Super Library for working with Rest API.

## Getting Started:

1. Clone this Library from github.

2. Add RestAPI project to current project/workspace.

3. Add RestAPI as dependences and Embed this binary into your project binary.

4. Create the response Model class

  ```
  // Station Data Model
  class StationData: SerializableModel {
      var ID = 0
      var Name = ""
      var Format = ""
      var BitRate = 0
      var Genre = ""
      var CurrentTrack = ""
  }
  ```

5. Create the RestAPI Settings

  ```
  // create the restAPI setting
  var restAPISettings = RestAPISetting(endPoint: "http://shoutcast.com")
  ```

6. Get the RestAPI Client

  ```
  var restAPI: RestAPI = Factory.get()
  ```

7. Start Querying

  ```
  restAPI.post("/Home/GetRandomStation") {
    (station: StationData) in
    // working with Station
  }
  ```

## More:

### Get Result As List

  ```
  // Get Top 500 stations
  restAPI.postAsList("/Home/Top") {
    (stations: [StationData]) in
    // working with Station
  }
  ```
  
### Nested class:

  ```
  class StationResponseData: SerializableModel {
    var CallBackDelay = 0
    var Station = StationData()
  }
  
  ///
  var params = ["StationId": 12345]
  restAPI.post("/Player/GetCurrentTrack", params: params)
  {
    (response: StationResponseData) in
  }
  ```
  
Uploading/ Downloading comming soon.
Any idea please send to tuoitrevohoc@me.com
