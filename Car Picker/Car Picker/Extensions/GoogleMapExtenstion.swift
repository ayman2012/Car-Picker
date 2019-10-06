//
//  GoogleMapExtenstion.swift
//  Car Picker
//
//  Created by Ayman Fathy on 10/4/19.
//

import Foundation
import GoogleMaps
import  UIKit

extension GMSMapView {
    var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.backgroundColor = .black
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }
    private func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.blue
        polyline.map = self
        self.addSubview(activityIndicator)

    }
    private func addMarker(positions: [CLLocationCoordinate2D]) {
        for index in 0..<positions.count {
            if index < positions.count - 1 {
                self.getPolylineRoute(from: positions[index], to: positions[index + 1])
            }
            let marker = GMSMarker()

            marker.position = positions[index]
            marker.title = "Source"
            marker.appearAnimation = .pop
            let camera = GMSCameraPosition.camera(withLatitude: positions[index].latitude, longitude: positions[index].longitude, zoom: 14.0)
            self.animate(to: camera)
            DispatchQueue.main.async {
                marker.map = self
            }
        }
    }

    func setUPMapWithMarkers(positionsInfo:Positions?){
        self.clear()
        if let positionsInfo = positionsInfo {
            var positions: [CLLocationCoordinate2D] = []
            let satrtPoint = CLLocationCoordinate2D.init(latitude: positionsInfo.startPostion.lat,
                                                         longitude: positionsInfo.startPostion.lng)
            let endPoint = CLLocationCoordinate2D.init(latitude: positionsInfo.endPostion.lat,
                                                       longitude: positionsInfo.endPostion.lng)
            positions.append(satrtPoint)
            for marker in positionsInfo.intermediateLoactions ?? [] {
                positions.append(CLLocationCoordinate2D.init(latitude: marker.lat, longitude: marker.lng))
            }
            positions.append(endPoint)
            self.addMarker(positions: positions)
        }
    }
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.activityIndicator.startAnimating()
        let url = URL(string: "\(Constants.googleMapBaseURl)\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyBGgDhXicjEjDjZ-OzTphjZa_KXiTW9r_8")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                print("error in JSONSerialization1")
                self.activityIndicator.stopAnimating()
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{

                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                print("error in JSONSerialization2")
                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }

                        if (routes.count > 0) {
                            let overview_polyline = routes[0] as? NSDictionary
                            let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                            let points = dictPolyline?.object(forKey: "points") as? String
                            DispatchQueue.main.async {
                                self.showPath(polyStr: points!)
                                self.activityIndicator.stopAnimating()

                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                print("error in JSONSerialization3")
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization4")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
    }
}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
