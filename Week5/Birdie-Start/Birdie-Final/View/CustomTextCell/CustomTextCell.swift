//
//  CustomTextCell.swift
//  Birdie-Final
//
//  Created by Janin Culhaoglu on 10/07/2020.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class CustomTextCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var textBody: UILabel!

    static let identifier = "CustomTextCell"

    static func nib() -> UINib {
        return UINib(nibName: "CustomTextCell", bundle: nil)
    }

    var post: TextPost? {
        didSet {
            guard let post = post else { return }
            userName.text = post.userName
            textBody.text = post.textBody
            timeStamp.text = FormatDate.formatDate(post.timestamp)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
