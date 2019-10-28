//
//  LocationModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
//

import Foundation

// MARK: - Location
class LocationModel: Codable, Equatable {
    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        return lhs.lat == rhs.lat && lhs.lng == rhs.lng
    }
    init(lng: Double, lat: Double) {
        self.lng = lng
        self.lat = lat
        self.event = nil
        self.address = nil
    }

    let event: String?
    let address: String?
    let lng, lat: Double
}
