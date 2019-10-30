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

    var bookedOpenedPublishSubject = PublishSubject<[CLLocationCoordinate2D]>()
    var statusChangePublisSubject = PublishSubject<Bool>()
    var vehicleLoactionPublisReplay = PublishSubject<CLLocationCoordinate2D>()
    var intermediateLoactionsPublishSubject = PublishSubject<[CLLocationCoordinate2D]>()
    var checkIfInVehicleStatusClosure: ((Bool) -> Void)?
    private var locations: [CLLocationCoordinate2D]? = []
    private var vehicleLocation: CLLocationCoordinate2D?
    private var disposeBag = DisposeBag()

     init() {
        configureBinding()
    }

    // MARK: - Functions

    private func configureBinding() {

    }

    @discardableResult
    func handelvehicleStatus(vehcileStatus: VehicleStatusModel) -> Bool {

        switch vehcileStatus {

        case .bookingOpened(let locationDataModel ):

            vehicleLocation =  CLLocationCoordinate2D.init(location: locationDataModel.vehicleLocation)
            var location = CLLocationCoordinate2D.init(location: locationDataModel.pickupLocation)
            locations?.append(location)

            for locationItem in locationDataModel.intermediateStopLocations ?? [] {
                location = CLLocationCoordinate2D.init(location: locationItem)
                locations?.append(location)
            }

            location = CLLocationCoordinate2D.init(location: locationDataModel.dropoffLocation)
            locations?.append(location)

            guard let locations = locations, let vehicleLoaction = vehicleLocation else { return false }
            let points = [vehicleLoaction, locations[0]]
            bookedOpenedPublishSubject.onNext(points)
			
        case .vehicleLocationUpdated(let vehicleLocationUpdatedModel):
            return setupVehicleLoaction(vehicleLocationModel: vehicleLocationUpdatedModel)
			
        case .statusUpdated(let statusModel):
            let invehicleStatus = checkIfInVehicleStatus(status: statusModel.status)
            intermediateLoactionsPublishSubject.onNext(locations ?? [])
            statusChangePublisSubject.onNext(invehicleStatus)
        
        case .intermediateStopLocationsChanged(let intermediateLoactionsModel):
            var dropOffLocation: CLLocationCoordinate2D?
            if !(locations?.isEmpty ?? true) {
                dropOffLocation = locations?.removeLast()
            }
            guard let vehicleLoaction = vehicleLocation else {return false}
            locations = [vehicleLoaction]
            for itermediateLocation in intermediateLoactionsModel.locations {
                locations?.append(CLLocationCoordinate2D.init(location: itermediateLocation))
            }
            if let dropOffLocation =  dropOffLocation {
                locations?.append(dropOffLocation)
            }
            intermediateLoactionsPublishSubject.onNext(locations ?? [])
        case .bookingClosed:
            locations = []
            vehicleLocation = nil

        case .other:
            return false
        }
        return true
    }

    @discardableResult
    private func setupVehicleLoaction(vehicleLocationModel: VehicleLocationUpdatedModel) -> Bool {
        vehicleLocation = CLLocationCoordinate2D.init(latitude: vehicleLocationModel.location.lat,
                                                      longitude: vehicleLocationModel.location.lng)
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
        }).disposed(by: disposeBag)
        return true
    }

    @discardableResult
    func stopConnection() -> Bool {
         SocketMananager.shared.connect().subscribe().dispose()
        return true
    }
}
