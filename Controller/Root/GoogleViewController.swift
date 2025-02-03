//
//  GoogleViewController.swift
//  Cario
//
//  Created by Teodik Abrami on 10/21/18.
//  Copyright © 2018 iPersianDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON


//Protocol
protocol HandleMapSearch: class {
    func searchBarSelectedItem(_ prediction: Prediction)
}

//Class
class GoogleViewController: UIViewController, GMSMapViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, HandleMapSearch, CLLocationManagerDelegate {
    
    var serviceElement: ServiceElement?
    var locationManager = CLLocationManager()
    var centerMapCoordinate = CLLocationCoordinate2D()
    var searchController: UISearchController!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerDelegateSetting()
        searchBarDelegates()
        updateUI()
    }
    
    func updateUI() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.689198, longitude: 51.388973, zoom: 16)
        mapView.camera = camera
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
        if let styleURL = Bundle.main.url(forResource: "googleMapStyle", withExtension: "json") {
            mapView.mapStyle = try! GMSMapStyle(contentsOfFileURL: styleURL)
        }
    }
    
    func searchBarDelegates() {
        let resultController = storyboard?.instantiateViewController(withIdentifier: MAP_SEARCH_CONTROLLER_ID) as! MapViewSearchTableViewController
        searchController = UISearchController(searchResultsController: resultController)
        searchController.searchResultsUpdater = resultController
        resultController.handleMapSearchDelegate = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.searchBarStyle = .default
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        self.definesPresentationContext = true
        SearchBarAppearence()
    }
    
    func SearchBarAppearence() {
        let backButton = UIBarButtonItem(title: "بازگشت", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!], for: .normal)
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.backBarButtonItem = backButton
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setValue("انصراف", forKey:"_cancelButtonText")
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "ناحیه خود را جستجو کنید ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue: UIFont(name: IRAN_SANS_MOBILE_FONT, size: 16)!])
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: IRAN_SANS_MOBILE_FONT, size: 15)!], for: .normal)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let geoLong = userLocation.coordinate.longitude
        let geoLat = userLocation.coordinate.latitude
        let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 16)
        mapView.camera = camera
        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        locationManager.stopUpdatingLocation()
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func searchByPlaceId(placeID: String,completion: @escaping (_ selectedLocation: CLLocationCoordinate2D) -> Void)  {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyAf0sKw2uMrV9n8r28Dz-AYc4T5-ctnQ8k&language=fa")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                let result = json["result"] as! [String:Any]
                let geometry = result["geometry"] as! [String:Any]
                let location = geometry["location"] as! [String:Any]
                let lat = location["lat"] as! Double
                let long = location["lng"] as! Double
                let selectedLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                completion(selectedLocation)
            }
            }.resume()
    }
    
    func searchBarSelectedItem(_ prediction: Prediction) {
        self.searchController.searchBar.text = prediction.description
        searchByPlaceId(placeID: prediction.placeID) { (location) in
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
                self.centerMapCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                UIView.animate(withDuration: 2, animations: {
                    CATransaction.begin()
                    CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
                    self.mapView.animate(to: camera)
                    CATransaction.commit()
                })
            }
        }
    }
    
    @IBAction func acceptButtonPressed(_ sender: RoundedButton) {
        if mapView.camera.zoom > 15 {
            guard DataManager.shared.selectedCar != nil else {
                let message = "شما هیج خودرویی را انتخاب نکرده اید !"
                self.presentWarningAlert(message: message)
                return
            }
            performSegue(withIdentifier: TO_LOCATION_SELECTED_SEGUE, sender: nil)
        } else {
            let message = "موقعیت را دقیق تر انتخاب نمایید"
            self.presentWarningAlert(message: message)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ServiceOrderViewController else { return }
        guard let serviceID = serviceElement?.serviceID else { return }
        vc.userSelectedLocation = centerMapCoordinate
        vc.serviceId = serviceID
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
