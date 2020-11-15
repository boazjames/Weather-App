//
//  Sendy_InterviewTests.swift
//  Sendy InterviewTests
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import XCTest
@testable import Sendy_Interview
import CoreData
import CoreLocation

class Sendy_InterviewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        clearLocationDb()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveAdress() {
        let result = saveAddress(address: "Nairobi", lat: 0.0, lng: 0.0)
        XCTAssertTrue(result)
    }
    
    func testFilterAdress() {
        let homeVc: HomeViewController = HomeViewController()
        var items: [NSManagedObject] = []
        
        if let item = createLocationEntity(location: "Nairobi", lat: 0.0, lng: 0.0) {
            items.append(item)
        }
        if let item = createLocationEntity(location: "Nakuru", lat: 0.0, lng: 0.0) {
            items.append(item)
        }
        if let item = createLocationEntity(location: "Kisumu", lat: 0.0, lng: 0.0) {
            items.append(item)
        }
        if let item = createLocationEntity(location: "Naivasha", lat: 0.0, lng: 0.0) {
            items.append(item)
        }
        if let item = createLocationEntity(location: "Mombasa", lat: 0.0, lng: 0.0) {
            items.append(item)
        }
        
        let result = homeVc.filterLocations(items: items, searchTerm: "nai")
        XCTAssertEqual(result.count, 2)
    }
    
    func testWeatherNetworkRequests() {
        let lat = -1.2102674, lng = 36.7927213
        let locationDetailsVc = LocationDetailsViewController()
        let expectation = self.expectation(description: "Fetching todays weather")
        
        var weatherRespose: TodayWeatherResponse? = nil
        var weatherError: Error? = nil
        locationDetailsVc.getWeather(lat: lat, lng: lng) { (response, error) in
            weatherError = error
            weatherRespose = response
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertNil(weatherError)
        XCTAssertNotNil(weatherRespose)
        XCTAssertEqual(weatherRespose!.cod, 200)
    }
    
    func testForecastNetworkRequests() {
        let lat = -1.2102674, lng = 36.7927213
        let locationDetailsVc = LocationDetailsViewController()
        let expectation = self.expectation(description: "Fetching 5 day weather forecast")
        
        var weatherRespose: Response? = nil
        var weatherError: Error? = nil
        locationDetailsVc.getForecasts(lat: lat, lng: lng) { (response, error) in
            weatherError = error
            weatherRespose = response
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertNil(weatherError)
        XCTAssertNotNil(weatherRespose)
        XCTAssertEqual(weatherRespose!.cod, "200")
    }
    
    func testReverseGeocode() {
        let lat = -1.2102674, lng = 36.7927213
        let location = CLLocation(latitude: lat, longitude: lng)
        
        var address: String? = nil
        let expectation = self.expectation(description: "Reverse Geocoding")
        location.lookUpLocationName { (name) in
            address = name
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        XCTAssertNotNil(address)
    }

}
