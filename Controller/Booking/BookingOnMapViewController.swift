//
//  BookingOnMapViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps

class BookingOnMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let places = BookingService.instance.placeSearch
    
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
    
    
    // Method
    func updateUI() {
        locationManagerDelegateSetting()
        if let styleURL = Bundle.main.url(forResource: "googleMapStyle", withExtension: "json") {
            mapView.mapStyle = try! GMSMapStyle(contentsOfFileURL: styleURL)
        }
        mapView.backgroundColor = #colorLiteral(red: 0.1330046058, green: 0.1969213188, blue: 0.2689081132, alpha: 1)
        self.addMarkersOnGoogleMap()
    }
    
    func addMarkersOnGoogleMap() {
        self.mapView.clear()
        for (index,place) in places.enumerated() {
            guard let lat = CLLocationDegrees.init(place.latitude) else { return }
            guard let long = CLLocationDegrees.init(place.longitude) else { return }
            let location = CLLocationCoordinate2D.init(latitude: lat, longitude: long)
            self.addMarker(addTo: location, title: place.title, tag: index)
        }
    }
    
    func locationManagerDelegateSetting() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    // GOOGLE MAP
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let geoLong = userLocation.coordinate.longitude
        let geoLat = userLocation.coordinate.latitude
        let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 15)
        mapView.camera = camera
        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //
    }
    
    // MARKER
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let icon = marker.iconView as? MarkerIconView else { return nil }
        let index = icon.tag
        let place = places[index]
        let frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        let marker = MarkerView(frame: frame, markerTitle: place.title)
        
        return marker
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.mapView.selectedMarker = marker
        
        return true
    }
    
    func addMarker(addTo location: CLLocationCoordinate2D, title: String, tag: Int) {
        let marker = GMSMarker.init(position: location)
        marker.iconView = MarkerIconView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        marker.iconView!.tag = tag
        marker.map = self.mapView
    }
    

}
