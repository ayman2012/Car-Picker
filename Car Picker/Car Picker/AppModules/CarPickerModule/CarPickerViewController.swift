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

class CarPickerViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerMapView: GMSMapView!
    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var intermediateLoactionLabel: UILabel!

    //MARK: variables
    private var carPickerViewModel: CarPickerViewModel?
    private let vecileMarker = GMSMarker()
    private var breviousPosition: CLLocationCoordinate2D?

    @IBAction func startTripAction(_ sender: Any) {

        if startTripButton.titleLabel?.text == "Cancel trip" {
            startTripButton.setTitle("Start a trip", for: .normal)
            startTripButton.setTitleColor(.blue, for: .normal)
            carPickerViewModel?.stopConnection()
        }else{
            startTripButton.setTitle("Cancel trip", for: .normal)
            startTripButton.setTitleColor(.red, for: .normal)
            carPickerViewModel?.startConnection()
        }
    }


    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        carPickerViewModel = CarPickerViewModel(viewController: self)
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

