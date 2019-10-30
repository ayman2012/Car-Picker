//
//  VehicleStatusModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/28/19.
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

    enum CodingKeys: String, CodingKey {
        case event
        case data
    }
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        let event = try values.decodeIfPresent(String.self, forKey: .event)
        switch event ?? "" {
        case Constants.VehicleSatsus.bookingOpened.rawValue:

            let model = try values.decodeIfPresent(BookingOpenedModel.self, forKey: .data)
            self = .bookingOpened(model: model!)

        case Constants.VehicleSatsus.vehicleLocationUpdated.rawValue:

            let model = try values.decodeIfPresent(LocationModel.self, forKey: .data)
            let vehicleLocationModel = VehicleLocationUpdatedModel.init(location: model!)
            self = .vehicleLocationUpdated(model: vehicleLocationModel)

        case Constants.VehicleSatsus.statusUpdated.rawValue:

            let status = try values.decodeIfPresent(String.self, forKey: .data)
            let statusModel = StatusUpdatedModel.init(status: status!)
            self = .statusUpdated(model: statusModel)

        case Constants.VehicleSatsus.intermediateStopLocationsChanged.rawValue:

            let model = try values.decodeIfPresent([LocationModel].self, forKey: .data)
            let intermediateLocations = IntermediateStopLocationsChangedModel.init(locations: model ?? [])
            self = .intermediateStopLocationsChanged(model: intermediateLocations)

        case Constants.VehicleSatsus.bookingClosed.rawValue:
            self = .other

        default:
            self = .other
        }
    }
}
extension VehicleStatusModel: Equatable {
    static func == (lhs: VehicleStatusModel, rhs: VehicleStatusModel) -> Bool {
        switch (lhs, rhs) {
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
