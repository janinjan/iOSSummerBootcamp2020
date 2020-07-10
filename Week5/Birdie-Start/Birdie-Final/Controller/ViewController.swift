//
//  ViewController.swift
//  Birdie-Final
//
//  Created by Jay Strawn on 6/18/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    var posts = [MediaPost]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        MediaPostsHandler.shared.getPosts()
        posts = MediaPostsHandler.shared.mediaPosts
    }

    func setUpTableView() {
        // Set delegates, register custom cells, set up datasource, etc.
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.register(CustomTextCell.nib(), forCellReuseIdentifier: CustomTextCell.identifier)
        tableview.register(CustomImageAndTextCell.nib(), forCellReuseIdentifier: CustomImageAndTextCell.identifier)
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {

    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]

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

extension ViewController: UITableViewDelegate {
    
}
