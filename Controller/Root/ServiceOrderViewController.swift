//
//  ServiceOrderViewController.swift
//  Cario
//
//  Created by Teodik Abrami on 10/21/18.
//  Copyright © 2018 iPersianDeveloper. All rights reserved.
//

import UIKit


class ServiceOrderViewController: UIViewController, ServiceOrderTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var providers: [Provider]?
    var userSelectedLocation: CLLocationCoordinate2D?
    var serviceId: String?
    var agreedButtonStatus = [Bool]()
    var selectedProvider: Provider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startIndicatorAnimate()
        tableView.delegate = self
        tableView.dataSource = self
        UpdateUI()
    }
    
    
    func UpdateUI() {
        let backButton = UIBarButtonItem(title: "بازگشت", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: IRAN_SANS_BOLD_MOBILE_FONT, size: 14)!], for: .normal)
        backButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.backBarButtonItem = backButton
        guard let userSelectedLocation = self.userSelectedLocation else { return }
        guard let serviceId = self.serviceId else { return }
        findProvidersInServiceID(serviceID: serviceId) { (providers) in
            DispatchQueue.main.async {
                self.agreedButtonStatus = []
                for provider in providers {
                    let path = GMSMutablePath()
                    for serviceArea in provider.serviceArea {
                        for points in serviceArea.points {
                            path.add(CLLocationCoordinate2D(latitude: Double(points.latitude)!, longitude: Double(points.longitude)!))
                        }
                    }
                    let isGeoInPoly = GMSGeometryContainsLocation(CLLocationCoordinate2D(latitude: userSelectedLocation.latitude, longitude: userSelectedLocation.longitude), path, false)
                    if isGeoInPoly {
                        self.agreedButtonStatus.append(true)
                    } else {
                        self.agreedButtonStatus.append(false)
                    }
                }
                self.providers = providers
                self.tableView.reloadData()
                self.stopIndicatorAnimate()
            }
        }
    }
    
    func findProvidersInServiceID(serviceID: String, completion: @escaping(_ providers: [Provider]) -> Void) {
        var allProviders = [Provider]()
        guard let carioInit = LoginService.instance.carioInit else { return }
        for services in carioInit.services {
            for service in services.service {
                if service.serviceID == serviceID {
                    for provider in service.provider {
                        allProviders.append(provider)
                    }
                }
            }
            completion(allProviders)
        }
    }
    
    // Actions
    func buttonPressed(cell: ServiceOrderTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let providers = self.providers else { return }
        selectedProvider = providers[indexPath.row]
        self.performSegue(withIdentifier: TO_ORDER_VIEW_CONTROLLER_SEGUE, sender: nil)
    }
    
    func areaButtonPressed(cell: ServiceOrderTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let providers = self.providers else { return }
        self.presentGeoViewController(serviceID: providers[indexPath.row].serviceID, providerID: providers[indexPath.row].providerID)
    }
}

extension ServiceOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let providers = providers {
            return providers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SERVICE_ORDER_CELL_ID, for: indexPath) as! ServiceOrderTableViewCell
        cell.delegate = self
        guard let provider = providers?[indexPath.row] else { return cell }
        cell.conifigureCell(providerName: provider.name, serviceName: provider.description, profileImageURL: provider.image , rateNumber: provider.rating, agreeButtonStatus: self.agreedButtonStatus[indexPath.row])
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedProvider = selectedProvider else { return }
        guard segue.identifier == TO_ORDER_VIEW_CONTROLLER_SEGUE else { return }
        let destionation = segue.destination as! OrderViewController
        destionation.provider = selectedProvider
        destionation.userSelectedLocation = userSelectedLocation
    }
    
    
}

