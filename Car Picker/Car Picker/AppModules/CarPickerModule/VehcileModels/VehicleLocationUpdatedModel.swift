//
//  VehicleLocationUpdatedModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
//

import Foundation

struct VehicleLocationUpdatedModel: Codable {
    let location: LocationModel
    init(location: LocationModel) {
        self.location = location
    }
}
