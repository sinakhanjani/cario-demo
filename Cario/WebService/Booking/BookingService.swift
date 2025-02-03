//
//  BookingService.swift
//  Cario
//
//  Created by Sinakhanjani on 8/27/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import GoogleMaps

class BookingService {
    
    static let instance = BookingService()
    
    var bookingCategory = [BookingCategory]()
    var placeSearch = [PlaceSearch]()
    
    func getAllCategoriesRequest(completion: @escaping COMPLETION_HANDLER) {
        guard let url = URL(string: BASE_URL + "?shop=1&ROUTE=PLACES&ACTION=PLACES_GET_ALL_CATEGORIES") else { completion(.server) ; return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let data = data else { completion(.data) ; return }
                let jsonDecoder = JSONDecoder()
                guard let bookingCategory = try? jsonDecoder.decode([BookingCategory].self, from: data) else { completion(.json) ; return }
                self.bookingCategory = bookingCategory
                completion(.success)
            } else {
                completion(.server)
            }
        }.resume()
    }
    
    func placeSearchRequest(distance: String, location: CLLocationCoordinate2D, catId: String, completion: @escaping COMPLETION_HANDLER) {
        let lat = location.latitude
        let long = location.longitude
        guard let url = URL(string: BASE_URL + "?shop=1&ROUTE=PLACES&ACTION=PLACES_SEARCH&LATITUDE=\(lat)&LONGITUDE=\(long)&DISTANCE=\(distance)&PLACES_CATEGORY_ID=\(catId)") else { completion(.server) ; return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let data = data else { completion(.data) ; return }
                let jsonDecoder = JSONDecoder()
                guard let placeSearch = try? jsonDecoder.decode([PlaceSearch].self, from: data) else { completion(.json) ; return }
                self.placeSearch = placeSearch
                completion(.success)
            } else {
                completion(.server)
            }
        }.resume()
    }
    
    
    
}
