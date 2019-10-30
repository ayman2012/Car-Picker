//
//  ViewController.swift
//  Car Picker
//
//  Created by Ayman Fathy on 9/29/19.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa
import Foundation

class CarPickerViewController: UIViewController, Storyboarded {

    // MARK: Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerMapView: GMSMapView!
    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var intermediateLoactionLabel: UILabel!

    // MARK: Variables

    private var carPickerViewModel: CarPickerViewModelProtocol?
    private let vecileMarker = GMSMarker()
    private let disposeBag = DisposeBag()

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataBinding()
    }

    // MARK: Functions

    func setupViewModel(viewModel: CarPickerViewModelProtocol) {
        self.carPickerViewModel = viewModel
    }

    private func setupDataBinding() {
        carPickerViewModel?
            .bookedOpenedPublishSubject
            .subscribe(onNext: { [weak self] locations in
            self?.updateMapWithMarkers(locations: locations)
        }).disposed(by: disposeBag)

        carPickerViewModel?
            .intermediateLoactionsPublishSubject
            .subscribe(onNext: { [weak self] loactions in
                self?.updateMapWithMarkers(locations: loactions)
         }).disposed(by: disposeBag)

        carPickerViewModel?
            .statusChangePublisSubject
            .subscribe(onNext: { [weak self] isInVehicle in
            self?.dimTripButton(enabled: !(isInVehicle))
        }).disposed(by: disposeBag)

        carPickerViewModel?
            .vehicleLoactionPublisReplay
            .scan(nil, accumulator: { [weak self] (previous, current) -> CLLocationCoordinate2D in
            self?.updateVehcileMarker(previous: previous, current: current)
            return current
        }).subscribe().disposed(by: disposeBag)
    }

    @IBAction func startTripAction(_ sender: Any) {
        if startTripButton.titleLabel?.text == Constants.ButtonStatus.cancel.rawValue {
            startTripButton.setTitle(Constants.ButtonStatus.start.rawValue, for: .normal)
            startTripButton.setTitleColor(.blue, for: .normal)
            carPickerViewModel?.stopConnection()
        } else {
            startTripButton.setTitle(Constants.ButtonStatus.cancel.rawValue, for: .normal)
            startTripButton.setTitleColor(.red, for: .normal)
            carPickerViewModel?.startConnection()
        }
    }
}

extension CarPickerViewController: CarPickerViewControllerProtocol {

    @discardableResult
    func updateVehcileMarker(previous: CLLocationCoordinate2D?, current: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        if previous == nil {
            addCarMarker(position: current)
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)
        let degrees = previous?.angle(to: current)
        vecileMarker.rotation = CLLocationDegrees((degrees ?? 0) + 90)
        vecileMarker.position = current
        CATransaction.commit()
        let camera = GMSCameraPosition.camera(withLatitude: current.latitude, longitude: current.longitude, zoom: 14)
        containerMapView.animate(to: camera)
        DispatchQueue.main.async {
            self.vecileMarker.map = self.containerMapView
        }
        return vecileMarker.position
    }

    @discardableResult
    private func addCarMarker(position: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        vecileMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
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
    func updateMapWithMarkers(locations: [CLLocationCoordinate2D]) -> Bool {
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
