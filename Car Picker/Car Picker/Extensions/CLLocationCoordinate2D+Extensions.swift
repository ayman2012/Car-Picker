//
//  CLLocationCoordinate2D+Extensions.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/4/19.
//
import UIKit
import Foundation
import CoreLocation

extension  CLLocationCoordinate2D {
    func angle(to comparisonPoint: CLLocationCoordinate2D) -> CGFloat {
        let originX = CGFloat(comparisonPoint.latitude) - CGFloat(self.latitude)
        let originY = CGFloat(comparisonPoint.longitude) - CGFloat(self.longitude)
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        return bearingDegrees
    }
   mutating func getLocation(location: LocationModel){
        latitude = location.lat
        longitude = location.lng
    }
   func isEqual(to:CLLocationCoordinate2D) -> Bool {
    return self.latitude == to.latitude && self.longitude == to.longitude
    }
}

extension CGFloat {
    var degrees: CGFloat {
        return self * CGFloat(180.0 / Double.pi)
    }
}
