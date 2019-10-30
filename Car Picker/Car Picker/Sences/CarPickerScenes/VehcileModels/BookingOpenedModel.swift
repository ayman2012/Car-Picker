//
//  BookingOpened.swift
//  Car Picker
//
//  Created by Ayman Fathy on 9/29/19.
//

import Foundation

struct BookingOpenedModel: Codable {
    let status: String?
    let vehicleLocation, pickupLocation, dropoffLocation: LocationModel?
    let intermediateStopLocations: [LocationModel]?
}
