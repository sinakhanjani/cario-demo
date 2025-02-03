//
//  DetailLocationFinderViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailLocationFinderViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeAndDistanceLabel: UILabel!
    
    var place: PlaceSearch?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var locationManager = CLLocationManager()
    var centerMapCoordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func callButtonPressed(_ sender: Any) {
        guard let place = place else { return }
        let telURL = "tel://\(place.phone)"
        if let url = URL(string: telURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func reserveButtonPressed(_ sender: Any) {
        //
    }
    
    @IBAction func directionButtonPressed(_ sender: Any) {
        self.mapView.clear()
        self.drawRouteOnMap()
    }
    
    // Method
    func updateUI() {
        locationManagerDelegateSetting()
        if let styleURL = Bundle.main.url(forResource: "googleMapStyle", withExtension: "json") {
            mapView.mapStyle = try! GMSMapStyle(contentsOfFileURL: styleURL)
        }
        mapView.backgroundColor = #colorLiteral(red: 0.1330046058, green: 0.1969213188, blue: 0.2689081132, alpha: 1)
        if let place = place {
            self.title = place.title
        }
    }
    
    func locationManagerDelegateSetting() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    func drawRouteOnMap() {
        guard let place = place else { return }
        let lat = CLLocationDegrees.init(place.latitude)!
        let long = CLLocationDegrees.init(place.longitude)!
        let destination = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        GoogleService.instance.draw(src: centerMapCoordinate, dst: destination, mapView: self.mapView) { (distance, minute) in
            DispatchQueue.main.async {
                self.addressLabel.text = place.address
                if let distance = distance, let minute = minute {
                    self.timeAndDistanceLabel.text = "\(distance) کیلومتر ، \(minute) دقیقه"
                }
            }
        }
        CATransaction.begin()
        CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
        let path = GMSMutablePath()
        path.add(centerMapCoordinate)
        path.add(destination)
        let bounds = GMSCoordinateBounds.init(path: path)
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 140))
        CATransaction.commit()
        addMarkersOnGoogleMap()
    }
    
    func addMarkersOnGoogleMap() {
        guard let place = place else { return }
        let lat = CLLocationDegrees.init(place.latitude)!
        let long = CLLocationDegrees.init(place.longitude)!
        let destination = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
        addMarker(addTo: centerMapCoordinate)
        addMarker(addTo: destination)
    }
    
    func addMarker(addTo location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.iconView = MarkerIconView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        marker.map = self.mapView
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.opacity = 1
        self.mapView.selectedMarker = marker
    }
    
    // GOOGLE MAP
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let geoLong = userLocation.coordinate.longitude
        let geoLat = userLocation.coordinate.latitude
        let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 16)
        mapView.camera = camera
        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        self.drawRouteOnMap()
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        let latitude = mapView.camera.target.latitude
//        let longitude = mapView.camera.target.longitude
//        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARKER
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        let placeName = place?.title ?? ""
        let marker = MarkerView(frame: frame, markerTitle: placeName)

        return marker
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        let frame = CGRect(x: 0, y: 0, width: 200, height: 40)
//        let placeName = place?.title ?? ""
//        let marker = MarkerView(frame: frame, markerTitle: placeName, translates: true)
//
//        return marker
//    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        
        return true
    }
    
    
}
