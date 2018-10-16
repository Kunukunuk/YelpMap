//
//  ReviewerCell.swift
//  YelpMap
//
//  Created by Kun Huang on 10/16/18.
//  Copyright © 2018 Kun Huang. All rights reserved.
//

import UIKit

class ReviewerCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    var reviewer: Reviewers? {
        didSet {
            if reviewer?.reviewerImage != nil {
                profileImageView.image = reviewer?.reviewerImage
            }
            if reviewer?.ratingImage != nil {
                ratingImage.image = reviewer?.ratingImage
            }
            postDate.text = reviewer?.dateCreated
            reviewerNameLabel.text = reviewer?.reviewerName
            ratingLabel.text = "\((reviewer?.rating)!)"
            reviewLabel.text = reviewer?.reviewText
            print("review: \(reviewer?.reviewText)")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
