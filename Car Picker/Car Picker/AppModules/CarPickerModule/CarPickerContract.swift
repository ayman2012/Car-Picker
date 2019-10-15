//
//  CarPickerContract.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/12/19.
//

import Foundation
import CoreLocation

protocol CarPickerViewControllerProtocol: class {
    func showVehcileMarker(position: CLLocationCoordinate2D)
    @discardableResult
    func updateMapWithMarkers(locations: [CLLocationCoordinate2D]) -> Bool
    func dimTripButton(enabled: Bool)
}
