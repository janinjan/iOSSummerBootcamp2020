//
//  CustomImageAndTextCell.swift
//  Birdie-Final
//
//  Created by Janin Culhaoglu on 10/07/2020.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class CustomImageAndTextCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var textBody: UILabel!
    @IBOutlet weak var postImageView: UIImageView!

    static let identifier = "CustomImageAndTextCell"

    static func nib() -> UINib {
        return UINib(nibName: "CustomImageAndTextCell", bundle: nil)
    }

    // Update the cell info
    var post: ImagePost? {
        didSet {
            guard let post = post else { return }
            userName.text = post.userName
            textBody.text = post.textBody
            postImageView.image = post.image
            timeStamp.text = FormatDate.formatDate(post.timestamp)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
