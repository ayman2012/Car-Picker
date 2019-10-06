//
//  Constants.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/4/19.
//

import Foundation
class Constants {

    static let mapKey = "AIzaSyBGgDhXicjEjDjZ-OzTphjZa_KXiTW9r_8"
    static let socketUrl = "wss://d2d-frontend-code-challenge.herokuapp.com"
    static let googleMapBaseURl = "https://maps.googleapis.com/maps/api/directions/json?origin="
    
    enum VehicleSatsus: String {
        case bookingOpened = "bookingOpened"
        case vehicleLocationUpdated = "vehicleLocationUpdated"
        case statusUpdated = "statusUpdated"
        case intermediateStopLocationsChanged = "intermediateStopLocationsChanged"
        case bookingClosed = "bookingClosed"
    }
}
