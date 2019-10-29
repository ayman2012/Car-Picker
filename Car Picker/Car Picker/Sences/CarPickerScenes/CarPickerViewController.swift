//
//  ViewController.swift
//  Car Picker
//
//  Created by Ayman Fathy on 9/29/19.
//

import UIKit
import Starscream
import GooglePlaces
import GoogleMaps
import Alamofire
import Foundation

class CarPickerViewController: UIViewController, Storyboarded {
   

    //MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerMapView: GMSMapView!
    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var intermediateLoactionLabel: UILabel!

    //MARK: variables
    private var carPickerViewModel: CarPickerViewModelProtocol?
    private let vecileMarker = GMSMarker()
    private var breviousPosition: CLLocationCoordinate2D?


    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataBinding()
    }

    func setupViewModel(viewModel: CarPickerViewModelProtocol) {
        self.carPickerViewModel = viewModel
    }

    private func setupDataBinding() {
        
        carPickerViewModel?.bookingOpenedClosure =  { [weak self] locations in
            self?.updateMapWithMarkers(locations: locations)
        }
        carPickerViewModel?.statusUpdatedClosure = { [weak self] locations in
            self?.updateMapWithMarkers(locations: locations)
        }
        carPickerViewModel?.intermediateStopLocationsChangedClosure = { [weak self] loactions in
            self?.updateMapWithMarkers(locations: loactions)
        }
        carPickerViewModel?.checkIfInVehicleStatusClosure = { [weak self] isEnabled in
            self?.dimTripButton(enabled: !(isEnabled))

        }

        carPickerViewModel?.vehicleLocationUpdatedClosure = { [weak self] location in
                self?.showVehcileMarker(position: location)
        }
    }

    @IBAction func startTripAction(_ sender: Any) {

        if startTripButton.titleLabel?.text == Constants.buttonStatus.cancel.rawValue {
            startTripButton.setTitle(Constants.buttonStatus.start.rawValue, for: .normal)
            startTripButton.setTitleColor(.blue, for: .normal)
            carPickerViewModel?.stopConnection()
        } else {
            startTripButton.setTitle(Constants.buttonStatus.cancel.rawValue, for: .normal)
            startTripButton.setTitleColor(.red, for: .normal)
            carPickerViewModel?.startConnection()
        }
    }
}
extension CarPickerViewController: CarPickerViewControllerProtocol {

    @discardableResult
    func showVehcileMarker(position: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        if breviousPosition == nil {
            addCarMarker(position: position)
        }

        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)
        let degrees = breviousPosition?.angle(to: position)
        breviousPosition = position
        vecileMarker.rotation = CLLocationDegrees((degrees ?? 0) + 90)
        vecileMarker.position = position
        CATransaction.commit()
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 14)
        containerMapView.animate(to: camera)
        DispatchQueue.main.async {
            self.vecileMarker.map = self.containerMapView
        }
        return vecileMarker.position
    }
    
    @discardableResult
    private func addCarMarker(position: CLLocationCoordinate2D) -> CLLocationCoordinate2D {

        breviousPosition = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        let degrees = breviousPosition?.angle(to: position)
        breviousPosition = position
        vecileMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        vecileMarker.rotation = CLLocationDegrees((degrees ?? 0) + 90)
        vecileMarker.icon = #imageLiteral(resourceName: "carIcon")
        vecileMarker.setIconSize(scaledToSize: CGSize.init(width: 25, height: 15))
        vecileMarker.appearAnimation = .pop
        vecileMarker.position = position
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 14)
        containerMapView.animate(to: camera)
        DispatchQueue.main.async {
            self.vecileMarker.map = self.containerMapView
        }
        return vecileMarker.position
    }

    @discardableResult
    func updateMapWithMarkers(locations: [CLLocationCoordinate2D])->Bool {

        if locations.isEmpty {
            return false
        }
        containerMapView.setUPMapWithMarkers(locationInfo: locations)
        return true
    }

    @discardableResult
    func dimTripButton(enabled: Bool) -> Bool {

        startTripButton.isEnabled = enabled
        return startTripButton.isEnabled
    }
}

