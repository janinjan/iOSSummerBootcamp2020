//
//  MediaPostsViewModel.swift
//  Birdie-Final
//
//  Created by Janin Culhaoglu on 11/07/2020.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class MediaPostsViewModel {

    static let shared = MediaPostsViewModel()
    private init() {}
    
    func createCell(post: MediaPost, in tableview: UITableView ,for indexPath: IndexPath) -> UITableViewCell {

        if post is TextPost {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: CustomTextCell.identifier, for: indexPath) as? CustomTextCell else { return UITableViewCell() }
            cell.post = post as? TextPost

            return cell
        } else if post is ImagePost {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: CustomImageAndTextCell.identifier, for: indexPath) as? CustomImageAndTextCell else { return UITableViewCell() }
            cell.post = post as? ImagePost

            return cell
        }
        return UITableViewCell()
    }
}
