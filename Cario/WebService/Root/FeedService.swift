//
//  FeedService.swift
//  Cario
//
//  Created by Sinakhanjani on 7/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FeedService {
    
    static let instance = FeedService()
    
    var rate: Rate?
    var contents: [Content] = []
    
    func feedBackRequest(feedRate: Int, feedCondition: String, message: String, orderId: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=FEEDBACK&MESSAGE=\(message)&ACTION=FEED_BACK_ORDER&ORDER_ID=\(orderId)&FEED_BACK_RATING=\(Double(feedRate))&FEED_BACK_MAIN_FEED_BACK=\(feedCondition)"
        guard let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { completion(.server) ; return }
        Alamofire.request(encodeURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let json = try? JSON(data: data) else { completion(.json) ; return }
                let message = json["message"].string
                if let message = message {
                    let rating = json["rating"].stringValue
                    let price = json["prize"].intValue
                    let rate = Rate.init(rate: rating, price: price, message: message)
                    self.rate = rate
                    completion(.success)
                } else {
                    completion(.failed)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func contentRequest(carId: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=CONTENT&USER_CAR=\(carId)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { completion(.data) ; return }
                guard let jsons = try? JSON(data: data).array else { completion(.json) ; return }
                guard let jsonArray = jsons else { completion(.json) ; return }
                self.contents.removeAll()
                for json in jsonArray {
                    let content_id = json["content_id"].stringValue
                    let content_title = json["content_title"].stringValue
                    let content_image = json["content_image"].stringValue
                    let content_text = json["content_text"].stringValue
                    let date = json["date"].stringValue
                    let views = json["views"].stringValue
                    let clike = json["clike"].stringValue
                    let ilike = json["ilike"].stringValue
                    let iview = json["iview"].stringValue
                    let content = Content.init(content_id: content_id, content_title: content_title, content_image: content_image, content_text: content_text, date: date, views: views, clike: clike, ilike: ilike, iview: iview)
                    self.contents.append(content)
                }
                completion(.success)
            } else {
                completion(.server)
            }
        }
    }
    
    func contentLikeRequest(contentId: String, isLiked: Bool, completion: @escaping COMPLETION_HANDLER) {
        let like = isLiked ? "1":"0"
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=CONTENT&ACTION=CONTENT_LIKE&LIKE=\(like)&CONTENT_ID=\(contentId)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseString { (response) in
            if response.result.error == nil {
                guard let message = response.result.value else { completion(.failed) ; return }
                if message == "like added" || message == "like removed" {
                    completion(.success)
                } else {
                    completion(.none)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func contentViewRequest(contentId: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=CONTENT&ACTION=CONTENT_VIEW&CONTENT_ID=\(contentId)"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseString { (response) in
            if response.result.error == nil {
                guard let message = response.result.value else { completion(.failed) ; return }
                if message == "ALREADY" || message == "OK" {
                    completion(.success)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    func feedBackService(message: String, completion: @escaping COMPLETION_HANDLER) {
        let url = BASE_URL + "?\(Authentication.auth.authQuery)" + "&ROUTE=FEEDBACK&MESSAGE=\(message)&ACTION=FEED_BACK_REQUEST_SERVICE"
        guard let encodeURL = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { completion(.server) ; return }
        Alamofire.request(encodeURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: JSON_HEAD).responseString { (response) in
            if response.result.error == nil {
                guard let message = response.result.value else { completion(.failed) ; return }
                if message == "SUCCESS" {
                    completion(.success)
                } else {
                    completion(.failed)
                }
            } else {
                completion(.server)
            }
        }
    }
    
    
}
