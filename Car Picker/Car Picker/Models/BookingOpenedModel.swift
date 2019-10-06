//
//  BookingOpened.swift
//  Car Picker
//
//  Created by Ayman Fathy on 9/29/19.
//

import Foundation
struct BaseModel: Codable {
    let event: String?
}
struct BookingOpenedModel: Codable {
    let data: DataClassMdoel?
}

// MARK: - DataClass
struct DataClassMdoel: Codable {
    let status: String
    let vehicleLocation, pickupLocation, dropoffLocation: LocationModel
    let intermediateStopLocations: [LocationModel]
}
struct VehicleLocationUpdatedModel: Codable {
    let event: String
    let data: LocationModel
}

// MARK: - Location
struct LocationModel: Codable {
    let event: String?
    let address: String?
    let lng, lat: Double
}
// MARK: - StatusUpdated
struct StatusUpdatedModel: Codable {
    let event, data: String
}
struct IntermediateStopLocationsChangedModel: Codable {
    let event: String
    let data: [LocationModel]
}
class Positions {
    var startPostion: LocationModel
    var endPostion: LocationModel
    var intermediateLoactions: [LocationModel]?
    init(start:LocationModel, end:LocationModel) {
        startPostion = start
        endPostion = end
    }
}
