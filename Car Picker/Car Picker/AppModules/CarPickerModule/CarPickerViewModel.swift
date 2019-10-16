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

    weak var viewController: CarPickerViewControllerProtocol!
    private var locations: [CLLocationCoordinate2D]? = []
    private var vehicleLocation: CLLocationCoordinate2D?

    init(viewController:CarPickerViewControllerProtocol) {
        self.viewController = viewController
    }

    var inVehicleStatus: Bool? {
        didSet {
            viewController.dimTripButton(enabled: !(inVehicleStatus ?? true))
        }
    }

    @discardableResult
    func setupVehicleLoaction(vehicleLocationModel: VehicleLocationUpdatedModel) -> Bool {
        vehicleLocation = CLLocationCoordinate2D.init(latitude: vehicleLocationModel.location.lat,
                                                      longitude: vehicleLocationModel.location.lng)
        guard let vehicleLocation = vehicleLocation else { return false}
        viewController.showVehcileMarker(position: vehicleLocation)
        return true
    }

    @discardableResult
    func handelvehicleStatus(json: String) -> Bool {
        guard let  status = getVehicleStatus(jsonResponse: json) else {return false}

        switch status {
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
            return viewController.updateMapWithMarkers(locations: [vehicleLoaction,locations[0]])

        case .vehicleLocationUpdated(let vehicleLocationUpdatedModel):
            return setupVehicleLoaction(vehicleLocationModel:vehicleLocationUpdatedModel)

        case .statusUpdated(let statusModel):
            checkIfInVehicleStatus(status:statusModel.status)
            return viewController.updateMapWithMarkers(locations: locations ?? [])

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
            return viewController.updateMapWithMarkers(locations: locations ?? [])
        case .bookingClosed:
            locations = []
            vehicleLocation = nil
            return true
        case .other:
            return false
        }
    }

    func getVehicleStatus(jsonResponse:String) -> VehicleStatusModel? {

        guard let jsonData = jsonResponse.data(using: .utf8) else { return nil }
        guard let status = try? JSONDecoder().decode(VehicleStatusModel.self, from: jsonData) else{ return nil }
        return status
    }

    @discardableResult
    func checkIfInVehicleStatus(status: String) -> Bool {

        if status == "inVehicle" {
            inVehicleStatus = true
            guard let location = vehicleLocation else { return false }
            guard var locationsData = locations, !locationsData.isEmpty else { return false}
            locationsData[0] = location
            return true
        }else{
            inVehicleStatus = false
            return false
        }
    }
    @discardableResult
    func startConnection() -> Bool {
        SocketMananager.shared.completionWithMessage = { [weak self] message in
            self?.handelvehicleStatus(json: message)
        }
        return SocketMananager.shared.startConnection()
    }
    @discardableResult
    func stopConnection() -> Bool {
        return SocketMananager.shared.stopConnection()
    }
}
