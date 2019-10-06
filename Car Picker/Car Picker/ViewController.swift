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

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerMapView: GMSMapView!

    @IBOutlet weak var startTripButton: UIButton!

    @IBOutlet weak var intermediateLoactionLabel: UILabel!
    @IBAction func startTripAction(_ sender: Any) {

        if startTripButton.titleLabel?.text == "Cancel trip" {
            startTripButton.setTitle("Start a trip", for: .normal)
            startTripButton.setTitleColor(.blue, for: .normal)
            stopConnection()
            containerMapView.clear()
        }else{
            startTripButton.setTitle("Cancel trip", for: .normal)
            startTripButton.setTitleColor(.red, for: .normal)
            startConnection()
        }
    }
    private var socket: WebSocket?
    private var positions: Positions?

    let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 14)
    let vecileMarker = GMSMarker()
    var breviousPosition = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConnection()
        containerMapView.accessibilityElementsHidden = false
        containerMapView.isMyLocationEnabled = true
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }

    override func viewDidLayoutSubviews() {
    }


    func setupVecileLoaction(vehicleLocation: VehicleLocationUpdatedModel) {
        let position = CLLocationCoordinate2D.init(latitude: vehicleLocation.data.lat, longitude: vehicleLocation.data.lng)
        showVecileMarker(position: position)
    }
    func handelVehicleStatusChange(status: String) {

        if status == "inVehicle" {
            startTripButton.isEnabled = false
        }else{
            startTripButton.isEnabled = true
        }
    }

    func showVecileMarker(position: CLLocationCoordinate2D) {
        vecileMarker.position = position
        vecileMarker.title = "Source"
        let degrees = breviousPosition.angle(to: position)
        breviousPosition = position
        vecileMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        vecileMarker.rotation = CLLocationDegrees(degrees + 90)
        vecileMarker.icon = #imageLiteral(resourceName: "carIcon")
        vecileMarker.setIconSize(scaledToSize: CGSize.init(width: 30, height: 20))
        vecileMarker.appearAnimation = .pop
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 14)
        containerMapView.animate(to: camera)
        DispatchQueue.main.async {
            self.vecileMarker.map = self.containerMapView
        }
    }

    func handelvehicleStatus(jsonResponse:String) {

        let jsonData = jsonResponse.data(using: .utf8)!
        let baseModel = try! JSONDecoder().decode(BaseModel.self, from: jsonData)
        if let status = Constants.VehicleSatsus.init(rawValue: baseModel.event!) {
            switch status {
            case .bookingOpened:
                let bookingOpenedModel = try! JSONDecoder().decode(BookingOpenedModel.self, from: jsonData)
                if let locationData = bookingOpenedModel.data {
                    positions = Positions.init(start: locationData.pickupLocation,
                        end: locationData.dropoffLocation)
                    positions?.intermediateLoactions = bookingOpenedModel.data?.intermediateStopLocations
                    containerMapView.setUPMapWithMarkers(positionsInfo: positions)
                }

            case .vehicleLocationUpdated:
                do {
                    let vehicleLocationUpdated = try JSONDecoder().decode(VehicleLocationUpdatedModel.self, from: jsonData)
                    setupVecileLoaction(vehicleLocation:vehicleLocationUpdated)
                } catch (let error){
                    print(error)
                }
            case .statusUpdated:
                let statusUpdated = try! JSONDecoder().decode(StatusUpdatedModel.self, from: jsonData)
                handelVehicleStatusChange(status:statusUpdated.data)
            case .intermediateStopLocationsChanged:
                let intermediateStopLocationsChanged = try! JSONDecoder().decode(IntermediateStopLocationsChangedModel.self, from: jsonData)
                positions?.intermediateLoactions?.append(contentsOf: intermediateStopLocationsChanged.data)
                containerMapView.setUPMapWithMarkers(positionsInfo: positions)
            case .bookingClosed:
                let bookingClosed = try! JSONDecoder().decode(BaseModel.self, from: jsonData)
            }
        } else {
            print("OOPs new case not handeled yet :(")
        }
    }
}
extension ViewController: WebSocketDelegate {


    private func setupConnection() {
        socket = WebSocket(url: URL(string: Constants.socketUrl)!)
        socket?.delegate = self
    }
    private func startConnection() {
        socket?.connect()
    }
    private func stopConnection() {
        socket?.disconnect()
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {

    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        handelvehicleStatus(jsonResponse: text)
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
}

