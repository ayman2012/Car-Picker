//
//  CarPickerViewModel.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/5/19.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class CarPickerViewModel: CarPickerViewModelProtocol {

    // MARK: - Variables

    var bookedOpenedPublishSubject = PublishSubject<[LocationModel]>()
    var statusChangePublisSubject = PublishSubject<Bool>()
    var vehicleLoactionPublisReplay = PublishSubject<LocationModel>()
    var intermediateLoactionsPublishSubject = PublishSubject<[LocationModel]>()
	var bookedClosedPublishSubject = PublishSubject<Bool>()
	var locationsPublisSubject = PublishSubject<[LocationModel]>()

    private var locations: [LocationModel]? = []
    private var vehicleLocation: LocationModel?
    private var disposeBag = DisposeBag()

    // MARK: - Functions

    @discardableResult
    func handelvehicleStatus(vehcileStatus: VehicleStatusModel) -> Bool {

        switch vehcileStatus {

        case .bookingOpened(let locationDataModel ):

            vehicleLocation = locationDataModel.vehicleLocation
			guard let pickupLocation =  locationDataModel.pickupLocation else { return false }
            locations?.append(pickupLocation)
            locations?.append(contentsOf: locationDataModel.intermediateStopLocations ?? [])
			guard let dropoffLocation =  locationDataModel.dropoffLocation else { return false }
            locations?.append(dropoffLocation)
            guard let locations = locations, let vehicleLoaction = vehicleLocation else { return false }
            let points = [vehicleLoaction, locations[0]]
            bookedOpenedPublishSubject.onNext(points)
			locationsPublisSubject.onNext(locations)

        case .vehicleLocationUpdated(let vehicleLocationUpdatedModel):
            return setupVehicleLoaction(vehicleLocationModel: vehicleLocationUpdatedModel)

        case .statusUpdated(let statusModel):
            let invehicleStatus = checkIfInVehicleStatus(status: statusModel.status)
            intermediateLoactionsPublishSubject.onNext(locations ?? [])
            statusChangePublisSubject.onNext(invehicleStatus)

        case .intermediateStopLocationsChanged(let intermediateLoactionsModel):
            var dropOffLocation: LocationModel?
            if !(locations?.isEmpty ?? true) {
                dropOffLocation = locations?.removeLast()
            }
            guard let vehicleLoaction = vehicleLocation else {return false}
            locations = [vehicleLoaction]
            for itermediateLocation in intermediateLoactionsModel.locations {
                locations?.append(itermediateLocation)
            }
            if let dropOffLocation =  dropOffLocation {
                locations?.append(dropOffLocation)
            }
            intermediateLoactionsPublishSubject.onNext(locations ?? [])
        case .bookingClosed:
            locations = []
            vehicleLocation = nil
			bookedClosedPublishSubject.onNext(true)
        case .other:
            return false
        }
        return true
    }

    @discardableResult
    private func setupVehicleLoaction(vehicleLocationModel: VehicleLocationUpdatedModel) -> Bool {
        vehicleLocation = vehicleLocationModel.location
        guard let vehicleLocation = vehicleLocation else { return false}
        vehicleLoactionPublisReplay.onNext(vehicleLocation)
        return true
    }

    @discardableResult
    private func checkIfInVehicleStatus(status: String) -> Bool {
        if status == Constants.inVehicle {
            guard let location = vehicleLocation else { return false }
            guard var locationsData = locations, !locationsData.isEmpty else { return false}
            locationsData[0] = location
            return true
        } else {
            return false
        }
    }

    @discardableResult
    func startConnection() -> Bool {
		SocketMananager.shared.connect().subscribe(onNext: {[weak self] vehiclestatus in
			self?.handelvehicleStatus(vehcileStatus: vehiclestatus)
			}, onError: { [weak self] _ in
				self?.bookedClosedPublishSubject.onNext(true)
		}).disposed(by: disposeBag)

        return true
    }

    @discardableResult
    func stopConnection() -> Bool {
         SocketMananager.shared.connect().subscribe().dispose()
        return true
    }
}
