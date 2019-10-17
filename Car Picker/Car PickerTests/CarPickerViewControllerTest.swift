//
//  CarPickerViewControllerTest.swift
//  Car PickerTests
//
//  Created by Ayman Fathy on 10/15/19.
//

import XCTest
import CoreLocation
@testable import Car_Picker

class CarPickerViewControllerTest: XCTestCase {

    func test_showVehcileMarker() {

        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CarPickerViewController") as! CarPickerViewController
        viewController.loadViewIfNeeded()
        let postion = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        XCTAssert(viewController.showVehcileMarker(position: postion).isEqual(to: postion))
    }

    func test_updateMapWithMarkers() {

        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CarPickerViewController") as! CarPickerViewController
        viewController.loadViewIfNeeded()
        let postion = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        XCTAssert(viewController.updateMapWithMarkers(locations: [postion]))
    }
    func test_dimTripButton() {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CarPickerViewController") as! CarPickerViewController
        viewController.loadViewIfNeeded()
        let postion = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        XCTAssert(viewController.dimTripButton(enabled: true))
    }

}
