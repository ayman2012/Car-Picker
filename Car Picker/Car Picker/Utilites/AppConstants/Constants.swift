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
        case bookingOpened
        case vehicleLocationUpdated
        case statusUpdated
        case intermediateStopLocationsChanged
        case bookingClosed
    }
    enum ButtonStatus: String {
        case cancel = "Cancel"
        case start = "Start"
    }
    static let inVehicle = "inVehicle"
	static let numberOfIntermediate = "intermediate loactions: \n"
	static let tripFinished = "your trip finished"
}
