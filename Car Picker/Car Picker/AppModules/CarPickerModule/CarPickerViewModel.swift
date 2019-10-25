//
//  CarPickerViewModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/5/19.
//

import Foundation
import CoreLocation

typealias completionCallback = ()->Void

class CarPickerViewModel {

    var bookingOpenedClosure: (([CLLocationCoordinate2D])->Void)?
    var statusUpdatedClosure: (([CLLocationCoordinate2D])->Void)?
    var intermediateStopLocationsChangedClosure: (([CLLocationCoordinate2D])->Void)?
    var checkIfInVehicleStatusClosure: ((Bool)->Void)?
    var vehicleLocationUpdatedClosure: ((CLLocationCoordinate2D)->Void)?
    
    private var locations: [CLLocationCoordinate2D]? = []
    private var vehicleLocation: CLLocationCoordinate2D?


    @discardableResult
    func handelvehicleStatus(vehcileStatus: VehicleStatusModel) -> Bool {

        switch vehcileStatus {
        case .bookingOpened(let locationDataModel ):
            vehicleLocation =  CLLocationCoordinate2D.init(latitude: locationDataModel.vehicleLocation?.lat ?? 0,
                                                           longitude: locationDataModel.vehicleLocation?.lng ?? 0)
            var location = CLLocationCoordinate2D.init(latitude: locationDataModel.pickupLocation?.lat ?? 0,
                                                       longitude: locationDataModel.pickupLocation?.lng ?? 0)
            locations?.append(location)

            for locationItem in locationDataModel.intermediateStopLocations ?? []{
                location = CLLocationCoordinate2D.init(latitude: locationItem.lat, longitude: locationItem.lng)
                locations?.append(location)
            }

            location = CLLocationCoordinate2D.init(latitude: locationDataModel.dropoffLocation?.lat ?? 0,
                                                   longitude: locationDataModel.dropoffLocation?.lng ?? 0)
            locations?.append(location)

            guard let locations = locations , let vehicleLoaction = vehicleLocation else {return false}
            bookingOpenedClosure?([vehicleLoaction,locations[0]])
        case .vehicleLocationUpdated(let vehicleLocationUpdatedModel):
            return setupVehicleLoaction(vehicleLocationModel:vehicleLocationUpdatedModel)

        case .statusUpdated(let statusModel):
            checkIfInVehicleStatus(status:statusModel.status)
            statusUpdatedClosure?(locations ?? [])

        case .intermediateStopLocationsChanged(let intermediateLoactionsModel):
            var dropOffLocation: CLLocationCoordinate2D?
            if !(locations?.isEmpty ?? true) {
                dropOffLocation = locations?.removeLast()
            }
            guard let vehicleLoaction = vehicleLocation else {return false}
            locations = [vehicleLoaction]
            for itermediateLocation in intermediateLoactionsModel.locations {
                locations?.append(CLLocationCoordinate2D.init(latitude: itermediateLocation.lat,
                                                              longitude: itermediateLocation.lng))
            }
            if let dropOffLocation =  dropOffLocation {
                locations?.append(dropOffLocation)
            }
            intermediateStopLocationsChangedClosure?(locations ?? [])
        case .bookingClosed:
            locations = []
            vehicleLocation = nil
        case .other:
            return false
        }
        return true
    }

    @discardableResult
    private func setupVehicleLoaction(vehicleLocationModel: VehicleLocationUpdatedModel) -> Bool {
        vehicleLocation = CLLocationCoordinate2D.init(latitude: vehicleLocationModel.location.lat,
                                                      longitude: vehicleLocationModel.location.lng)
        guard let vehicleLocation = vehicleLocation else { return false}
        vehicleLocationUpdatedClosure?(vehicleLocation)
        return true
    }

    @discardableResult
    private func checkIfInVehicleStatus(status: String) -> Bool {

        if status == "inVehicle" {
            checkIfInVehicleStatusClosure?(true)
            guard let location = vehicleLocation else { return false }
            guard var locationsData = locations, !locationsData.isEmpty else { return false}
            locationsData[0] = location
            return true
        }else{
            checkIfInVehicleStatusClosure?(false)
            return false
        }
    }

    @discardableResult
    func startConnection() -> Bool {
        SocketMananager.shared.completionWithMessage = { [weak self] vehcileStatus in
            self?.handelvehicleStatus(vehcileStatus: vehcileStatus)
        }
        return SocketMananager.shared.startConnection()
    }
    
    @discardableResult
    func stopConnection() -> Bool {
        return SocketMananager.shared.stopConnection()
    }
}
