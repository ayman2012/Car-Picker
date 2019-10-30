//
//  IntermediateStopLocationsChangedModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
//

import Foundation

struct IntermediateStopLocationsChangedModel: Codable {
    let locations: [LocationModel]
    init(locations: [LocationModel]) {
        self.locations = locations
    }
}
