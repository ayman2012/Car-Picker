//
//  CarPickerViewModelTest.swift
//  Car PickerTests
//
//  Created by Ayman Fathy on 10/24/19.
//

import XCTest
import Quick
import Nimble
import CoreLocation
@testable import Car_Picker
// swiftlint:disable force_unwrapping
// swiftlint:disable force_try

class CarPickerViewModelQuickTest: QuickSpec {

    override func spec() {

        var viewModel: CarPickerViewModel?

        beforeEach {
             ViewModel = CarPickerViewModel()
        }

        context("when new BookingOpened Status") {

            var vehcileStatus: VehicleStatusModel?
            beforeEach {

                if let jsonData = TestHelper().loadStubDataFromBundle(name: "BookingOpenedStatus", extension: "json") {
                     vehcileStatus = try! JSONDecoder().decode(VehicleStatusModel.self, from: jsonData)
                }
            }
            it("should handel and return locations in BookingOpenedClosur") {
                viewModel?.bookingOpenedClosure = { loactions in
                    expect(loactions).notTo(beEmpty())
                }
                viewModel?.handelvehicleStatus(vehcileStatus: vehcileStatus!)
            }
        }
        context("when new itermediate status") {

            var vehcileStatus: VehicleStatusModel?
            beforeEach {

                if let jsonData = TestHelper().loadStubDataFromBundle(name: "BookingOpenedStatus", extension: "json") {
                    vehcileStatus = try! JSONDecoder().decode(VehicleStatusModel.self, from: jsonData)
                }
            }
            it("should handel it and return loaction with new intermediate loaction") {
                let mockedIntermediateLocation =  ViewModel?.intermediateStopLocationsChangedClosure = { loactions in
//                    expect(loactions[1]).To

                }

                viewModel?.handelvehicleStatus(vehcileStatus: vehcileStatus!)

                if let jsonData = TestHelper().loadStubDataFromBundle(name: "IntermediateStopLocationsChangedTest", extension: "json") {
                    vehcileStatus = try! JSONDecoder().decode(VehicleStatusModel.self, from: jsonData)
                }
                viewModel?.handelvehicleStatus(vehcileStatus: vehcileStatus!)

            }
        }
    }
}
