//
//  CarPickerViewModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/5/19.
//

import Foundation
typealias completionCallback = ()->Void
class CarPickerViewModel {

    init() {
        setupConnection?()
    }

    var startTrip: Bool? {
        didSet {
            if startTrip ?? false {
                startConnection?()
            }else{
                stopConnection?()
            }
        }
    }
    var startConnection: completionCallback?
    var stopConnection: completionCallback?
    var setupConnection: completionCallback?
}
