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

        context("when new json response") {

            var jsonResponse: String?

            beforeEach {

                if let jsonData = TestHelper().loadStubDataFromBundle(name: "BookingOpenedStatus", extension: "json") {
                    jsonResponse = String.init(data: jsonData, encoding: .utf8)
                }
            }
        }
    }
}
