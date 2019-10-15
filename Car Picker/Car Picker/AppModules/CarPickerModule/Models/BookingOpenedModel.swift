//
//  BookingOpened.swift
//  Car Picker
//
//  Created by Ayman Fathy on 9/29/19.
//

import Foundation

enum VehicleStatusModel: Decodable {
    func encode(to encoder: Encoder) throws {

    }

    case bookingOpened(model:BookingOpenedModel)
    case vehicleLocationUpdated(model:VehicleLocationUpdatedModel)
    case statusUpdated(model:StatusUpdatedModel)
    case intermediateStopLocationsChanged(model:IntermediateStopLocationsChangedModel)
    case bookingClosed
    case other

    enum CodingKeys: String,CodingKey {
        case event
        case data
    }
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        let event = try values.decodeIfPresent(String.self, forKey: .event)
        switch event ?? "" {
        case "bookingOpened":
            let model = try values.decodeIfPresent(BookingOpenedModel.self, forKey: .data)
            self = .bookingOpened(model: model!)


        case "vehicleLocationUpdated":
            let model = try values.decodeIfPresent(LocationModel.self, forKey: .data)
            let vehicleLocationModel = VehicleLocationUpdatedModel.init(location: model!)
            self = .vehicleLocationUpdated(model: vehicleLocationModel)


        case "statusUpdated":
            let status = try values.decodeIfPresent(String.self, forKey: .data)
            let statusModel = StatusUpdatedModel.init(status: status!)
            self = .statusUpdated(model: statusModel)

        case "intermediateStopLocationsChanged":
            let model = try values.decodeIfPresent([LocationModel].self, forKey: .data)
            let intermediateLocations = IntermediateStopLocationsChangedModel.init(locations: model ?? [])
            self = .intermediateStopLocationsChanged(model: intermediateLocations)

        case "bookingClosed":
            self = .other

        default:
            self = .other
        }
    }
}
extension VehicleStatusModel: Equatable {
    static func == (lhs: VehicleStatusModel, rhs: VehicleStatusModel) -> Bool {
        switch (lhs , rhs) {
        case (let .bookingOpened(lhsModel), let .bookingOpened(rhsModel)):
            return lhsModel.pickupLocation == rhsModel.pickupLocation
        case (let .vehicleLocationUpdated(lhsModel), let .vehicleLocationUpdated(rhsModel)):
            return lhsModel.location == rhsModel.location
        case (let .statusUpdated(lhsModel), let .statusUpdated(rhsModel)):
            return lhsModel.status == rhsModel.status
        case (let .intermediateStopLocationsChanged(lhsModel), let .intermediateStopLocationsChanged(rhsModel)):
            return lhsModel.locations == rhsModel.locations
        case (.bookingClosed, .bookingClosed):
            return true
        case(.other, .other):
            return true
        default:
            return false
        }
    }
}




//------------------------
struct BookingOpenedModel: Codable {
    let status: String?
    let vehicleLocation, pickupLocation, dropoffLocation: LocationModel?
    let intermediateStopLocations: [LocationModel]?
}

// MARK: - DataClass
//struct DataClassMdoel: Codable {
//    let status: String
//    let vehicleLocation, pickupLocation, dropoffLocation: LocationModel
//    let intermediateStopLocations: [LocationModel]
//}
struct VehicleLocationUpdatedModel: Codable {
    let location: LocationModel
    init(location: LocationModel) {
        self.location = location
    }
}
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

// MARK: - StatusUpdated
struct StatusUpdatedModel: Codable {
    let status: String
    init(status: String) {
        self.status = status
    }
}
struct IntermediateStopLocationsChangedModel: Codable {
    let locations: [LocationModel]
    init(locations:[LocationModel]) {
        self.locations = locations
    }
}
