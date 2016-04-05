//
//  RequestDispatcherTest.swift
//  WeatherApp
//
//  Created by Vitalie Jurjiu on 4/5/16.
//  Copyright © 2016 Vitalie Jurjiu. All rights reserved.
//

import XCTest
@testable import WeatherApp
import OCMock

class RequestDispatcherTest: XCTestCase {
    
    var mockRequestDispatcher = OCMockObject.mockForClass(RequestDispatcher)
    
    let params = ["test":"test"]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformRequest() {
    }
}
