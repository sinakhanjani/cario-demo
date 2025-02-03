//
//  GoogleService.swift
//  Cario
//
//  Created by Sinakhanjani on 8/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleService {
    
    static let instance = GoogleService()
    
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D, mapView: GMSMapView, completion: @escaping (_ distance: Double?,_ minute: Int?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=driving&key=AIzaSyAf0sKw2uMrV9n8r28Dz-AYc4T5-ctnQ8k")!
        print(url)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                completion(nil,nil)
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        let preRoutes = json["routes"] as! NSArray
                        let routes = preRoutes[0] as! NSDictionary
                        let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                        let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                        let legs = routes.value(forKey: "legs") as! NSArray
                        let leg = legs[0] as! NSDictionary
                        let distance = leg["distance"] as! NSDictionary
                        let duration = leg["duration"] as! NSDictionary
                        let meter: Double = Double(distance["value"] as! Int) / 1000.0
                        let minute: Int = (duration["value"] as! Int) / 60
                        completion(meter,minute)
                        DispatchQueue.main.async(execute: {
                            let path = GMSPath(fromEncodedPath: polyString)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 5.0
                            polyline.strokeColor = UIColor.green
                            polyline.map = mapView
                        })
                    }
                    
                } catch {
                    completion(nil,nil)
                    print("parsing error")
                }
            }
        })
        task.resume()
    }
    
    func distanceInMeters(from: CLLocation, dst: CLLocation) -> Double {
        let distance = from.distance(from: dst)
        
        return distance
    }
    
    
    
}
