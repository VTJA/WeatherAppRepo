//
//  CachingManagerTest.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 3/22/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import XCTest
@testable import WeatherApp

class CachingManagerTest: XCTestCase {
    
    let cachingManagerInstance = CachingManager()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidateForecasts() {
        let forecastDate : NSTimeInterval = NSDate().timeIntervalSince1970 - 86400
        let forecast = Forecast()
        
        forecast.dt = forecastDate
        
        XCTAssertFalse(cachingManagerInstance.validateForecasts(forecast))
        
        
        
        let forecastDate2 : NSTimeInterval = NSDate().timeIntervalSince1970 - 86300
        let forecast2 = Forecast()
        
        forecast2.dt = forecastDate2
        
        XCTAssertTrue(cachingManagerInstance.validateForecasts(forecast2))
    }
    
}

