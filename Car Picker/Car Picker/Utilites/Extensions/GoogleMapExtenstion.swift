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

    func setUPMapWithMarkers(locationInfo: [CLLocationCoordinate2D]) {
        self.clear()
        self.addMarker(positions: locationInfo)
   }

    private func addMarker(positions: [CLLocationCoordinate2D]) {

        for index in 0..<positions.count {

            if index < positions.count - 1 {
                self.getPolylineRoute(from: positions[index], to: positions[index + 1])
            }

            let marker = GMSMarker()
            marker.position = positions[index]
			marker.icon = #imageLiteral(resourceName: "pickUpLocation")
			marker.setIconSize(scaledToSize: CGSize.init(width: 30, height: 50))
            DispatchQueue.main.async {
                marker.map = self
            }
        }
    }

    private func showPath(polyStr: String) {

        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.blue
        polyline.map = self
        self.addSubview(activityIndicator)
    }
    private func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        self.activityIndicator.startAnimating()
        guard let url = URL(string: "\(Constants.googleMapBaseURl)\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyBGgDhXicjEjDjZ-OzTphjZa_KXiTW9r_8") else { return }
        let task = session.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                print("error in JSONSerialization1")
                self.activityIndicator.stopAnimating()
            } else {
                do {
                    guard let data = data else { return }
                    if let json: [String: Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                        guard let routes = json["routes"] as? [Any] else {
                            DispatchQueue.main.async {
                                print("error in JSONSerialization2")
                                self.activityIndicator.stopAnimating()
                            }
                            return
                        }
                        if !(routes.isEmpty) {
                            let overviewPolyline = routes[0] as? [String: Any]
                            let dictPolyline = overviewPolyline?["overview_polyline"] as? NSDictionary
                            guard let points = dictPolyline?.object(forKey: "points") as? String else { return }
                            DispatchQueue.main.async {
                                self.showPath(polyStr: points)
                                self.activityIndicator.stopAnimating()
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("error in JSONSerialization3")
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                } catch {
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
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
