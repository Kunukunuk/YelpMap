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
    
    let rating: NSNumber?
    let reviewText: String?
    let dateCreated: String?
    let reviewerName: String?
    let reviewerImage: URL?
    let ratingImage: UIImage?
    
    init(dictionary: [String: Any]) {
        
        rating = dictionary["rating"] as? NSNumber
        
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
        reviewerImage = URL(string: urlString!)
        
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
