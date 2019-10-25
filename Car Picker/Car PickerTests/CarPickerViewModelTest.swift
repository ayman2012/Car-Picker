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

    func test_handelvehicleStatusWithBookOpened() {

        let carpickerViewModel = CarPickerViewModel()
        guard let vehcileStatus = try? JSONDecoder().decode(VehicleStatusModel.self, from: MockedData.bookingOpened!) else{ return }
        let status = carpickerViewModel.handelvehicleStatus(vehcileStatus: vehcileStatus)
        XCTAssert(status)
    }

    func test_handelvehicleLocationUpdated() {

        let carpickerViewModel = CarPickerViewModel()
        guard let vehcileStatus = try? JSONDecoder().decode(VehicleStatusModel.self, from: MockedData.vehicleLocationUpdated!) else{ return }
        let status = carpickerViewModel.handelvehicleStatus(vehcileStatus: vehcileStatus)
        XCTAssert(status)
    }

    func test_handelvehicleStatusWithIntermediatStatus() {

        let carpickerViewModel = CarPickerViewModel()
        guard let vehcileStatus = try? JSONDecoder().decode(VehicleStatusModel.self, from: MockedData.intermediateStatus!) else{ return }
        guard let vehcilebookingOpenedStatus = try? JSONDecoder().decode(VehicleStatusModel.self, from: MockedData.bookingOpened!) else{ return }

        let _ = carpickerViewModel.handelvehicleStatus(vehcileStatus: vehcilebookingOpenedStatus)

        let status = carpickerViewModel.handelvehicleStatus(vehcileStatus: vehcileStatus)
        XCTAssert(status)
    }

    func test_handelvehicleStatusChange() {

        let carpickerViewModel = CarPickerViewModel()
        guard let vehcileStatus = try? JSONDecoder().decode(VehicleStatusModel.self, from: MockedData.statusChanged!) else{ return }
        let status = carpickerViewModel.handelvehicleStatus(vehcileStatus: vehcileStatus)
        XCTAssert(status)
    }

    func test_startConnection() {

        let carpickerViewModel = CarPickerViewModel()
        XCTAssert(carpickerViewModel.startConnection())

    }

    func test_stopConnection() {

        let carpickerViewModel = CarPickerViewModel()
        carpickerViewModel.startConnection()
        XCTAssert(carpickerViewModel.stopConnection())
    }
}

struct MockedData {

    static var bookingOpened: Data? {
       return TestHelper().loadStubDataFromBundle(name: "BookingOpenedStatus", extension: "json")
    }
    static var intermediateStatus: Data? {
        return TestHelper().loadStubDataFromBundle(name: "IntermediateStopLocationsChangedTest", extension: "json")
    }
    static var vehicleLocationUpdated: Data? {
        return TestHelper().loadStubDataFromBundle(name: "VehicleLocationUpdatedStatus", extension: "json")
    }
    static var statusChanged: Data? {
        return TestHelper().loadStubDataFromBundle(name: "StatusUpdated", extension: "json")
    }

}
