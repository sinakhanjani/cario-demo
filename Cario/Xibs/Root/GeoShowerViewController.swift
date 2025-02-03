//
//  GeoShowerViewController.swift
//  Cario
//
//  Created by Teodik Abrami on 10/22/18.
//  Copyright © 2018 iPersianDeveloper. All rights reserved.
//

import UIKit
import GooglePlaces


class GeoShowerViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    private var renderer: GMUGeometryRenderer!
    private var geoJsonParser: GMUGeoJSONParser!
    
    var serviceID: String?
    var providerID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        self.showAnimate()
        self.dismissesKeyboardByTouch()
        configureTouchXibViewController(bgView: bgView)
        let camera = GMSCameraPosition.camera(withLatitude: 35.689198, longitude: 51.388973, zoom: 10)
        mapView.camera = camera
        guard let serviceID = serviceID, let providerID = providerID else { return }
        changingJSONFormat(serviceID: serviceID, providerID: providerID)
    }
    
    
    func changingJSONFormat(serviceID: String, providerID: String) {
        var allPoints = Array<Any>()
        var path = GMSMutablePath()
        var paths = [path]
        var googleFormatedDictionary = [String:Any]()
        guard let carioJson = LoginService.instance.carioInit else { return }
        for services in carioJson.services {
            for service in services.service {
                for provider in service.provider {
                    if provider.providerID == providerID && provider.serviceID == serviceID {
                        for serviceArea in provider.serviceArea {
                            var arrayOfPoints = Array<Array<Double>>()
                            path = GMSMutablePath()
                            for pointCount in 0...serviceArea.points.count - 1 {
                                path.add(CLLocationCoordinate2D(latitude: Double(serviceArea.points[pointCount].latitude)!, longitude: Double(serviceArea.points[pointCount].longitude)!))
                                arrayOfPoints.append([Double(serviceArea.points[pointCount].longitude)! , Double(serviceArea.points[pointCount].latitude)!])
                            }
                            paths.append(path)
                            googleFormatedDictionary.updateValue("MultiPolygon", forKey: "type")
                            googleFormatedDictionary.updateValue([[arrayOfPoints]], forKey: "coordinates")
                            allPoints.append(googleFormatedDictionary)
                        }
                    }
                }
            }
        }
        drawPolygon(allPoints: allPoints)
        
    }
    // polygon o rasm mikone
    func drawPolygon(allPoints: [Any]) {
        DispatchQueue.main.async {
            for everyPoint in allPoints {
                let jsonData = try! JSONSerialization.data(withJSONObject: everyPoint, options: [])
                self.geoJsonParser = GMUGeoJSONParser.init(data: jsonData)
                self.geoJsonParser.parse()
                self.renderer = GMUGeometryRenderer(map: self.mapView, geometries: self.geoJsonParser.features)
                self.geoJsonParser.features.first!.style = GMUStyle(styleID: "feat_1", stroke: UIColor.white, fill: UIColor(red: 85, green: 0, blue: 189, alpha: 0.1) , width: 5, scale: 1, heading: 1, anchor: CGPoint.zero, iconUrl: nil, title: "title", hasFill: true, hasStroke: true)
                self.renderer.render()
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        removeAnimate()
    }
    
}
