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
