//
//  Reviewers.swift
//  YelpMap
//
//  Created by Kun Huang on 10/16/18.
//  Copyright © 2018 Kun Huang. All rights reserved.
//

import Foundation
import UIKit

class Reviewers: NSObject {
    
    let rating: Double?
    let reviewText: String?
    let dateCreated: String?
    let reviewerName: String?
    let reviewerImage: UIImage?
    let ratingImage: UIImage?
    
    init(dictionary: [String: Any]) {
        
        rating = dictionary["rating"] as? Double
        
        switch rating {
        case 1:
            self.ratingImage = UIImage(named: "stars_1")
            break
        case 1.5:
            self.ratingImage = UIImage(named: "stars_1half")
            break
        case 2:
            self.ratingImage = UIImage(named: "stars_2")
            break
        case 2.5:
            self.ratingImage = UIImage(named: "stars_2half")
            break
        case 3:
            self.ratingImage = UIImage(named: "stars_3")
            break
        case 3.5:
            self.ratingImage = UIImage(named: "stars_3half")
            break
        case 4:
            self.ratingImage = UIImage(named: "stars_4")
            break
        case 4.5:
            self.ratingImage = UIImage(named: "stars_4half")
            break
        case 5:
            self.ratingImage = UIImage(named: "stars_5")
            break
        default:
            self.ratingImage = UIImage(named: "stars_0")
            break
        }
        
        reviewText = dictionary["text"] as? String
        
        dateCreated = dictionary["time_created"] as? String
        
        let user = dictionary["user"] as? NSDictionary
        
        reviewerName = user!["name"] as? String
        let urlString = user!["image_url"] as? String
        let imageURL = URL(string: urlString!)
        if let data = try? Data(contentsOf: imageURL!) {
            reviewerImage = UIImage(data: data)
        } else {
            reviewerImage = UIImage(named: "Food")
        }
        
    }
    
    class func reviews(yelpReviwers: [[String: Any]]) -> [Reviewers] {
        var reviews = [Reviewers]()
        for reviwer in yelpReviwers {
            let review = Reviewers(dictionary: reviwer)
            reviews.append(review)
        }
        return reviews
    }
    
}
