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
    class carPickerViewController: CarPickerViewControllerProtocol {

        func showVehcileMarker(position: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
            return position
        }

        func dimTripButton(enabled: Bool) -> Bool {
            return enabled
        }

        func updateMapWithMarkers(locations: [CLLocationCoordinate2D]) -> Bool {
            return true
        }

    }

    func test_handelvehicleStatusWithBookOpened() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let status = carpickerViewModel.handelvehicleStatus(json: MockedData.bookingOpened)
        XCTAssert(status)
    }
    func test_handelvehicleLocationUpdated() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let status = carpickerViewModel.handelvehicleStatus(json: MockedData.vehicleLocationUpdated)
        XCTAssert(status)
    }
    func test_handelvehicleStatusWithIntermediatStatus() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let _ = carpickerViewModel.handelvehicleStatus(json: MockedData.bookingOpened)
        let status = carpickerViewModel.handelvehicleStatus(json: MockedData.intermediateStatus)
        XCTAssert(status)
    }
    func test_handelvehicleStatusChange() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let status = carpickerViewModel.handelvehicleStatus(json: MockedData.statusChanged)
        XCTAssert(status)
    }
    func test_getVehicleStatus() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let status = carpickerViewModel.getVehicleStatus(jsonResponse: MockedData.bookingOpened)
        XCTAssertNotNil(status)
        let stupedModel = BookingOpenedModel.init(status: "", vehicleLocation: nil, pickupLocation: LocationModel.init(lng: 30.3, lat: 40.4), dropoffLocation: nil, intermediateStopLocations: nil)
        XCTAssertEqual(status, VehicleStatusModel.bookingOpened(model: stupedModel), "booking openned successfuly")
    }

    func test_checkIfInVehicleStatus() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        carpickerViewModel.handelvehicleStatus(json: MockedData.bookingOpened)
        carpickerViewModel.checkIfInVehicleStatus(status: "inVehicle")
        XCTAssert(carpickerViewModel.inVehicleStatus ?? false)
    }
    func test_checkIfInVehicleStatusfasle() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        carpickerViewModel.handelvehicleStatus(json: MockedData.bookingOpened)
        carpickerViewModel.checkIfInVehicleStatus(status: "notInVehicle")
        XCTAssertEqual(carpickerViewModel.inVehicleStatus ?? true , false)
    }
    func test_setupVehicleLoaction() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        let stupedModel = LocationModel.init(lng: 30.3, lat: 40.4)
        carpickerViewModel.handelvehicleStatus(json: MockedData.bookingOpened)
        XCTAssert(carpickerViewModel.setupVehicleLoaction(vehicleLocationModel: VehicleLocationUpdatedModel.init(location: stupedModel)))
    }

    func test_checkIfInVehicleStatusWithCarLoaction() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        carpickerViewModel.handelvehicleStatus(json: MockedData.bookingOpened)
        XCTAssert(carpickerViewModel.checkIfInVehicleStatus(status: "inVehicle"))
    }
    func test_startConnection() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        XCTAssert(carpickerViewModel.startConnection())

    }

    func test_stopConnection() {

        let carpickerView = carPickerViewController()
        let carpickerViewModel = CarPickerViewModel(viewController: carpickerView)
        carpickerViewModel.startConnection()
        XCTAssert(carpickerViewModel.stopConnection())
    }
}

struct MockedData {
    static let bookingOpened = """
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
    static let intermediateStatus = """
                                    {
                                    "event": "intermediateStopLocationsChanged",
                                    "data": [
                                    {
                                    "lat": 10.1,
                                    "lng": 20.2,
                                    "address": "Street Address of Some Stop On The Way"
                                    },
                                    {
                                    "lat": 30.3,
                                    "lng": 40.4,
                                    "address": "Another Street Address of Some Other Stop On The Way"
                                    }
                                    ]
                                    }
                                    """
    static let vehicleLocationUpdated = """
                                {
                                      "event": "vehicleLocationUpdated",
                                      "data": {
                                        "address": null,
                                        "lng": 10.1,
                                        "lat": 20.2
                                      }
                                    }
                                """
    static let statusChanged = """
                                {
                                      "event": "statusUpdated",
                                      "data": "inVehicle"
                                    }

                                """

}
