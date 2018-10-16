//
//  DetailsViewController.swift
//  YelpMap
//
//  Created by Kun Huang on 10/16/18.
//  Copyright © 2018 Kun Huang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var categoriesListLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var restaurant: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if restaurant != nil {
            if restaurant?.imageURL != nil {
                if let data = try? Data(contentsOf: restaurant!.imageURL!) {
                    restaurantImageView.image = UIImage(data: data)
                }
            }
            
            if restaurant?.ratingImage != nil {
                ratingImageView.image = restaurant?.ratingImage
            }
            
            restaurantNameLabel.text = restaurant?.name
            categoriesListLabel.text = restaurant?.categories
            phoneLabel.text = restaurant?.phoneNumber
            ratingLabel.text = "\((restaurant?.rating)!)"
        }
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
