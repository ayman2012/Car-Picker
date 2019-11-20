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
    func updateVehcileMarker(previous: LocationModel?, current: LocationModel) -> CLLocationCoordinate2D?

    @discardableResult
    func updateMapWithMarkers(locations: [LocationModel]) -> Bool

    @discardableResult
    func dimTripButton(enabled: Bool) -> Bool
}

protocol CarPickerViewModelProtocol {

    var bookedOpenedPublishSubject: PublishSubject<[LocationModel]> { get }
    var statusChangePublisSubject: PublishSubject<Bool> { get }
    var vehicleLoactionPublisReplay: PublishSubject<LocationModel> { get set }
    var intermediateLoactionsPublishSubject: PublishSubject<[LocationModel]> { get }
	var bookedClosedPublishSubject: PublishSubject<Bool> { get }
	var locationsPublisSubject: PublishSubject<[LocationModel]> { get }
    @discardableResult
    func handelvehicleStatus(vehcileStatus: VehicleStatusModel) -> Bool

    @discardableResult
    func startConnection() -> Bool

    @discardableResult
    func stopConnection() -> Bool
}
