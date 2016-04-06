//
//  RequestDispatcherTest.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 4/5/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import XCTest
@testable import WeatherApp
import OHHTTPStubs


class RequestDispatcherTest: XCTestCase {
    
    let requestDispatcher = RequestDispatcher.sharedInstance
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testServerSideErrorHandling() {
        // given
        stub(isHost("api.openweathermap.org")) { _ in
            
            return OHHTTPStubsResponse(JSONObject: ["":""], statusCode: 404, headers: nil)
        }
        
        let expectation = expectationWithDescription("Expectation")
        // when
        requestDispatcher.performRequest(WeatherEndpoint.ForecastByDays, parameters: ["":""]) { (forecasts: [Forecast]?, error: NSError?) in
            // then
            XCTAssert(error != nil && (error?.localizedFailureReason?.containsString("404"))!)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(60) { error in
            print(error)
        }
    }
    
    func testGetMatchingCitiesSuccess() {
        // given
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource("stubJSON", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)
        let stubbedJSON = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions())
        let
        
        print(stubbedJSON)
        let params = ["q":"Lon",
                      "appid": WeatherAPIKey,
                      "units": "metric",
                      "type": "like" ,
                      "mode": "json"]
        
        stub(isHost("api.openweathermap.org") && isPath(WeatherEndpoint.Search.path)) { _ in
            return OHHTTPStubsResponse(JSONObject: stubbedJSON!, statusCode: 200, headers: nil)
        }
        
        // when
        
        requestDispatcher.performRequest(WeatherEndpoint.Search, parameters: ["":""]) {(forecasts: [City]?, error: NSError?) in
            XCTAssertTrue(error == nil && forecasts[0] == )
        }
    }
}
