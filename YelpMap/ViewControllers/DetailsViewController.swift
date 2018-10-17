//
//  DetailsViewController.swift
//  YelpMap
//
//  Created by Kun Huang on 10/16/18.
//  Copyright © 2018 Kun Huang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var categoriesListLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var totalReviewLabel: UILabel!
    
    
    var restaurant: Restaurant?
    var reviwers: [Reviewers]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if restaurant != nil {
            if restaurant?.imageURL != nil {
                if let data = try? Data(contentsOf: restaurant!.imageURL!) {
                    restaurantImageView.image = UIImage(data: data)
                }
            }
        }
            
        if restaurant?.ratingImage != nil {
            ratingImageView.image = restaurant?.ratingImage
        }
        
        restaurantNameLabel.text = restaurant?.name
        categoriesListLabel.text = restaurant?.categories
        phoneLabel.text = restaurant?.phoneNumber
        if restaurant?.rating != nil {
            ratingLabel.text = "\((restaurant?.rating)!)"
        }
        totalReviewLabel.text = "\((restaurant?.reviewCount)!) Reviews"
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        getReviews()
            
    }
    
    func getReviews() {
        APIManager().getRestaurantReviews(with: (restaurant?.id)!, completion: { (reviwers: [Reviewers]?, error: Error?) in
            if let error = error {
                print("error getting reviews: \(error.localizedDescription)")
            } else {
                print("successful gettiung reviews")
                self.reviwers = reviwers
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviwers?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewerCell", for: indexPath) as! ReviewerCell
        if reviwers != nil {
            cell.reviewer = reviwers?[indexPath.row]
        }
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
