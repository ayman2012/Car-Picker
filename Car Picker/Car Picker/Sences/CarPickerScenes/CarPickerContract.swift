//
//  CarPickerContract.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/12/19.
//

import Foundation
import RxSwift
import RxCocoa

import CoreLocation

protocol CarPickerViewControllerProtocol: class {

    @discardableResult
    func updateVehcileMarker(previous: CLLocationCoordinate2D?, current: CLLocationCoordinate2D) -> CLLocationCoordinate2D?

    @discardableResult
    func updateMapWithMarkers(locations: [CLLocationCoordinate2D]) -> Bool

    @discardableResult
    func dimTripButton(enabled: Bool) -> Bool
}

protocol CarPickerViewModelProtocol {

    var bookedOpenedPublishSubject: PublishSubject<[CLLocationCoordinate2D]> { get }
    var statusChangePublisSubject: PublishSubject<Bool> { get }
    var vehicleLoactionPublisReplay: PublishSubject<CLLocationCoordinate2D> { get set }
    var intermediateLoactionsPublishSubject: PublishSubject<[CLLocationCoordinate2D]> { get }

    @discardableResult
    func handelvehicleStatus(vehcileStatus: VehicleStatusModel) -> Bool

    @discardableResult
    func startConnection() -> Bool

    @discardableResult
    func stopConnection() -> Bool
}
