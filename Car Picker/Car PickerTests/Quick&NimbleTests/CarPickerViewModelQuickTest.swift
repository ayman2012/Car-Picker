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
class CarPickerViewModelQuickTest: QuickSpec {

    override func spec() {

        var ViewModel: CarPickerViewModel?

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
                ViewModel?.bookingOpenedClosure = { loactions in
                    expect(loactions).notTo(beEmpty())
                }
                ViewModel?.handelvehicleStatus(vehcileStatus: vehcileStatus!)
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
                let mockedIntermediateLocation = 
                ViewModel?.intermediateStopLocationsChangedClosure = { loactions in
//                    expect(loactions[1]).To

                }

                ViewModel?.handelvehicleStatus(vehcileStatus: vehcileStatus!)

                if let jsonData = TestHelper().loadStubDataFromBundle(name: "IntermediateStopLocationsChangedTest", extension: "json") {
                    vehcileStatus = try! JSONDecoder().decode(VehicleStatusModel.self, from: jsonData)
                }
                ViewModel?.handelvehicleStatus(vehcileStatus: vehcileStatus!)

            }
        }
    }
}
