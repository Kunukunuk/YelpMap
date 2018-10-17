//
//  APIManager.swift
//  YelpMap
//
//  Created by Kun Huang on 10/15/18.
//  Copyright © 2018 Kun Huang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class APIManager {
    
    static let apiKey = "izCFqEx0usiPwAiv_ymJ4Sl2Lr_mpnN6U_VeEkn1iUyEUWLM2Rd76A6NlswCI-HlYVWYT2WYRFtNnD04lgageyBKPJkqDDA75C8UsJYwc7oXWMGDFSCRU93zoTBaW3Yx"
    static let baseURLString = "https://api.yelp.com/v3/businesses/search"
    
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func getRestaurants(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ([Restaurant]?, Error?) -> Void) {
        
        let parameter = "term=Restaurant&location=\(latitude),\(longitude)&limit=50"
        let url = URL(string: APIManager.baseURLString + "?" + parameter)!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.setValue("Bearer \(APIManager.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    
                let restaurants = dataDictionary["businesses"] as! [[String: Any]]
                
                completion(Restaurant.restaurant(restaurantsDict: restaurants), nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getRestaurantReviews(with restaurantId: String, completion: @escaping ([Reviewers]?, Error?) -> Void) {
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/\(restaurantId)/reviews")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.setValue("Bearer \(APIManager.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let reviewers = dataDictionary["reviews"] as! [[String: Any]]
                
                completion(Reviewers.reviews(yelpReviwers: reviewers), nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    /*func showLoading(result: Bool) {
        
        let presentViewController = UIApplication.shared.keyWindow?.rootViewController
        let pVC = (presentViewController?.presentedViewController)!
        
        let loading = MBProgressHUD.showAdded(to: pVC.view, animated: true)
        loading.label.text = "Getting Data"
        
        loading.mode = .customView
        if result {
            loading.customView = UIImageView(image: UIImage(named: "check.png"))
        } else {
            loading.customView = UIImageView(image: UIImage(named: "error.png"))
        }
        loading.label.text = "Finished"
        loading.hide(animated: true, afterDelay: 1)
    }*/
}
