//
//  CLLocationCoordinate2DTest.swift
//  Car PickerTests
//
//  Created by Ayman Fathy on 10/17/19.
//

import XCTest
import CoreLocation

@testable import Car_Picker

class CLLocationCoordinate2DTest: XCTestCase {

    func test_angle() {

        let firstLocation = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        let secondLocation = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        let degree = firstLocation.angle(to: secondLocation)
        XCTAssertEqual(degree, 0,"the angle between (0,0) and (0,0) are 0")
    }

    func test_getLocation() {

        let locationModel = LocationModel.init(lng: 0, lat: 0)
        var newLocation = CLLocationCoordinate2D.init(location: locationModel)
        let expectedLocation = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        XCTAssertEqual(newLocation, expectedLocation)
    }
}
