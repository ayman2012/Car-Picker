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

    @IBOutlet weak var containerMapView: GMSMapView!
    @IBOutlet weak var startTripButton: UIButton!
	@IBOutlet weak var startView: UIView! {
		didSet {
			startView.layer.cornerRadius = startView.bounds.height / 2
		}
	}
	@IBOutlet weak var statusImageView: UIImageView!
	@IBOutlet weak var pickUpLabel: UILabel!
	@IBOutlet weak var dropOffLabel: UILabel!

    // MARK: Variables

    private var carPickerViewModel: CarPickerViewModelProtocol?
    private let vecileMarker = GMSMarker()
    private let disposeBag = DisposeBag()
	enum ButtonStatusStyle {
		case start
		case cancel
	}
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataBinding()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		self.navigationController?.setNavigationBarHidden(false, animated: false)
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
			.locationsPublisSubject
			.subscribe(onNext: { [weak self] locations in
				self?.showTripLocationsInfo(loactions: locations)
			}).disposed(by: disposeBag)

        carPickerViewModel?
            .intermediateLoactionsPublishSubject
            .subscribe(onNext: { [weak self] locations in
                self?.updateMapWithMarkers(locations: locations)
         }).disposed(by: disposeBag)

        carPickerViewModel?
            .statusChangePublisSubject
            .subscribe(onNext: { [weak self] isInVehicle in
				if isInVehicle {
					self?.statusImageView.image = #imageLiteral(resourceName: "inTheVehicle")
					if self?.startView != nil {
						self?.startView.isHidden = true
					}
					self?.dimTripButton(enabled: !(isInVehicle))
				} else {
					self?.startView.isHidden = false
					self?.dimTripButton(enabled: true)
					self?.statusImageView.image = #imageLiteral(resourceName: "droppedOff")
				}
        }).disposed(by: disposeBag)

        carPickerViewModel?
            .vehicleLoactionPublisReplay
            .scan(nil, accumulator: { [weak self] (previous, current) -> LocationModel in
            self?.updateVehcileMarker(previous: previous, current: current)
            return current
        }).subscribe().disposed(by: disposeBag)

		carPickerViewModel?
		.bookedClosedPublishSubject
			.subscribe(onNext: { [weak self] _ in
				self?.clearTripStatus()
			}).disposed(by: disposeBag)
    }

    @IBAction func startTripAction(_ sender: Any) {
        if startTripButton.titleLabel?.text == Constants.ButtonStatus.cancel.rawValue {
			setupStartButton(style: ButtonStatusStyle.cancel)
        } else {
			setupStartButton(style: ButtonStatusStyle.start)
        }
    }

	private func showTripLocationsInfo(loactions: [LocationModel] = []) {
		if loactions.count > 1 {
			pickUpLabel.text = loactions[0].address
			dropOffLabel.text = loactions.last?.address
		} else {
			pickUpLabel.text = ""
			dropOffLabel.text = ""
		}
	}
	private func setupStartButton(style: ButtonStatusStyle) {
		switch style {
		case .start:
			startTripButton.setTitle(Constants.ButtonStatus.cancel.rawValue, for: .normal)
			startTripButton.setTitleColor(.red, for: .normal)
			statusImageView.image = #imageLiteral(resourceName: "waiting")
			carPickerViewModel?.startConnection()
		case .cancel:
			clearTripStatus()
		}
	}
	private func clearTripStatus() {
		startTripButton.setTitle(Constants.ButtonStatus.start.rawValue, for: .normal)
		startTripButton.setTitleColor(.blue, for: .normal)
		statusImageView.image = #imageLiteral(resourceName: "droppedOff")
		carPickerViewModel?.stopConnection()
		containerMapView.clear()
		showTripLocationsInfo()
	}
}

extension CarPickerViewController: CarPickerViewControllerProtocol {

    @discardableResult
    func updateVehcileMarker(previous: LocationModel?, current: LocationModel) -> CLLocationCoordinate2D? {
        if previous == nil {
            addCarMarker(position: current)
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.5)
		let current = CLLocationCoordinate2D.init(location: current)
		let degrees = CLLocationCoordinate2D.init(location: previous).angle(to: current)
		vecileMarker.rotation = CLLocationDegrees((degrees))
        vecileMarker.position = current
        CATransaction.commit()
        if !isMarkerWithinScreen(marker: vecileMarker) {
            let camera = GMSCameraPosition.camera(withLatitude: current.latitude, longitude: current.longitude, zoom: 14)
            containerMapView.animate(to: camera)
        }
        DispatchQueue.main.async {
            self.vecileMarker.map = self.containerMapView
        }
        return vecileMarker.position
    }
    private func isMarkerWithinScreen(marker: GMSMarker) -> Bool {
        let region = self.containerMapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        return bounds.contains(marker.position)
    }
    @discardableResult
    private func addCarMarker(position: LocationModel) -> CLLocationCoordinate2D {
		let position = CLLocationCoordinate2D.init(location: position)
        vecileMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
		vecileMarker.icon = #imageLiteral(resourceName: "vehicle")
        vecileMarker.setIconSize(scaledToSize: CGSize.init(width: 18, height: 30))
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
    func updateMapWithMarkers(locations: [LocationModel]) -> Bool {
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
