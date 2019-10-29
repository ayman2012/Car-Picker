//
//  CarPickerContract.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/12/19.
//

import Foundation
import CoreLocation

protocol CarPickerViewControllerProtocol: class {

    @discardableResult
    func showVehcileMarker(position: CLLocationCoordinate2D) -> CLLocationCoordinate2D

    @discardableResult
    func updateMapWithMarkers(locations: [CLLocationCoordinate2D]) -> Bool
    
    @discardableResult
    func dimTripButton(enabled: Bool) -> Bool
}

protocol CarPickerViewModelProtocol {

    var bookingOpenedClosure: (([CLLocationCoordinate2D])->Void)? { get set }
    var statusUpdatedClosure: (([CLLocationCoordinate2D])->Void)? { get set }
    var intermediateStopLocationsChangedClosure: (([CLLocationCoordinate2D])->Void)? { get set }
    var checkIfInVehicleStatusClosure: ((Bool)->Void)? { get set }
    var vehicleLocationUpdatedClosure: ((CLLocationCoordinate2D)->Void)? { get set }

    @discardableResult
    func handelvehicleStatus(vehcileStatus: VehicleStatusModel) -> Bool

    @discardableResult
    func startConnection() -> Bool
    
    @discardableResult
    func stopConnection() -> Bool

}
