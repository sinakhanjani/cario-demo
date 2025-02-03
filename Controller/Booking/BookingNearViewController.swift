//
//  BookingNearViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class BookingNearViewController: UIViewController, CLLocationManagerDelegate, NearTableViewCellDelegate {
    
    func buttonPressed(cell: NearTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let index = indexPath.row
            self.performSegue(withIdentifier: BOOKING_NEAR_TO_DETAIL_LOCATION_SEGUE, sender: index)
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    let locationManager = CLLocationManager()
    var booking: BookingCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Action
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard let booking = booking else { return }
        guard let location = locationManager.location?.coordinate else {
            return
        }
        let value = Int(sender.value)
        distanceLabel.text = "\(value / 1000)" + " " + "گیلومتری"
        self.startIndicatorAnimate()
        BookingService.instance.placeSearchRequest(distance: String(value), location: location, catId: booking.id) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    @IBAction func mapButtonPressed(_ sender: RoundedButton) {
        self.performSegue(withIdentifier: BOOKING_NEAR_TO_ON_MAP_LOCATION_SEGUE, sender: nil)
    }
    
    // Method
    func updateUI() {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled")
        }
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        navigationItem.backBarButtonItem = backButton
        fetchPlaceSearch()
    }
    
    func fetchPlaceSearch() {
        guard let booking = booking else { return }
        self.title = booking.name
        let url = BASE_URL + booking.image
        iconImageView.loadImageUsingCache(withUrl: url)
        subjectLabel.text = "فهرست" + " " + booking.name + " " + "در شعاع" + " " + "\(Int(distanceSlider.value) / 1000)" + " " + "گیلومتری"
        distanceLabel.text = "\(Int(distanceSlider.value) / 1000)" + " " + "گیلومتری"
        guard let location = locationManager.location?.coordinate else {
            let message = "جی پی اس دستگاه خود را روشن نمایید !"
            self.presentWarningAlert(message: message)
            return
        }
        self.startIndicatorAnimate()
        BookingService.instance.placeSearchRequest(distance: "\(Int(distanceSlider.value))", location: location, catId: booking.id) { (status) in
            self.webServiceAlert(withType: status, escape: { (status) in
                if status == .success {
                    DispatchQueue.main.async {
                        self.stopIndicatorAnimate()
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BOOKING_NEAR_TO_DETAIL_LOCATION_SEGUE {
            let index = sender as! Int
            let place = BookingService.instance.placeSearch[index]
            let destination = segue.destination as! DetailLocationFinderViewController
            destination.place = place
        }
        
        if segue.identifier == BOOKING_NEAR_TO_ON_MAP_LOCATION_SEGUE {
            let destination = segue.destination as! BookingOnMapViewController
            destination.title = self.title
        }
    }

    // MARK: - CoreLocation Delegate Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //
    }
    
}


extension BookingNearViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return BookingService.instance.placeSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NEAR_CELL, for: indexPath) as! NearTableViewCell
        let place = BookingService.instance.placeSearch[indexPath.row]
        cell.configureCell(name: place.title, detail: place.address)
        cell.delegate = self
        
        return cell
    }
}
