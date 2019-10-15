//
//  CarPickerViewModelTest.swift
//  Car PickerTests
//
//  Created by Ayman Fathy on 10/12/19.
//

import XCTest
import CoreLocation
@testable import Car_Picker

class CarPickerViewModelTest: XCTestCase {
    class carPickerViewContrller: CarPickerViewControllerProtocol {

        func showVehcileMarker(position: CLLocationCoordinate2D) {

        }

        func updateMapWithMarkers(locations: [CLLocationCoordinate2D]) -> Bool {
            return true
        }

        func dimTripButton(enabled: Bool) {

        }
    }

    func test_handelvehicleStatus() {

        let carpickerView = carPickerViewContrller()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let json = """
                        {
                        "event": "bookingOpened",
                        "data": {
                        "status": "waitingForPickup",
                        "vehicleLocation": {
                        "address": null,
                        "lng": 10.1,
                        "lat": 20.2
                        },
                        "pickupLocation": {
                        "address": "The street address of the pickup location",
                        "lng": 30.3,
                        "lat": 40.4
                        },
                        "dropoffLocation": {
                        "address": "The street address of the dropoff location",
                        "lng": 50.5,
                        "lat": 60.6
                        },
                        "intermediateStopLocations": [
                        {
                        "address": "The intermediate stops that will be made between pickup and dropoff",
                        "lng": 70.7,
                        "lat": 80.8
                        }
                        ]
                        }
                        }
                 """
        let status = carpickerViewModel.handelvehicleStatus(json: json)
        XCTAssert(status)
        //        XCTAssertNotNil(status)
        //        XCTAssertEqual(status, true, "booking openned successfuly")
    }
    func test_getVehicleStatus() {

        let carpickerView = carPickerViewContrller()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let json = """
                        {
                        "event": "bookingOpened",
                        "data": {
                        "status": "waitingForPickup",
                        "vehicleLocation": {
                        "address": null,
                        "lng": 10.1,
                        "lat": 20.2
                        },
                        "pickupLocation": {
                        "address": "The street address of the pickup location",
                        "lng": 30.3,
                        "lat": 40.4
                        },
                        "dropoffLocation": {
                        "address": "The street address of the dropoff location",
                        "lng": 50.5,
                        "lat": 60.6
                        },
                        "intermediateStopLocations": [
                        {
                        "address": "The intermediate stops that will be made between pickup and dropoff",
                        "lng": 70.7,
                        "lat": 80.8
                        }
                        ]
                        }
                        }
                 """
        let status = carpickerViewModel.getVehicleStatus(jsonResponse: json)
        XCTAssertNotNil(status)
        let stupedModel = BookingOpenedModel.init(status: "", vehicleLocation: nil, pickupLocation: LocationModel.init(lng: 30.3, lat: 40.4), dropoffLocation: nil, intermediateStopLocations: nil)
        XCTAssertEqual(status, VehicleStatusModel.bookingOpened(model: stupedModel), "booking openned successfuly")
    }
    func test_checkIfInVehicleStatus() {
        let carpickerView = carPickerViewContrller()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        XCTAssert(carpickerViewModel.checkIfInVehicleStatus(status: "inVehicle"))
    }
    func test_setupVehicleLoaction() {
        let carpickerView = carPickerViewContrller()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let stupedModel = LocationModel.init(lng: 30.3, lat: 40.4)
        XCTAssert(carpickerViewModel.setupVehicleLoaction(vehicleLocationModel: VehicleLocationUpdatedModel.init(location: stupedModel)))
        XCTAssert(carpickerViewModel.checkIfInVehicleStatus(status: "inVehicle"))
    }
    func test_checkIfInVehicleStatusWithCarLoaction() {
        let carpickerView = carPickerViewContrller()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        XCTAssert(carpickerViewModel.checkIfInVehicleStatus(status: "inVehicle"))
    }

}
