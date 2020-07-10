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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        MediaPostsHandler.shared.getPosts()
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
       displayTextPostAlert()
    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {

    }

    private func displayTextPostAlert() {
        let alert = UIAlertController(title: "Add new post", message: "", preferredStyle: .alert)

        alert.addTextField { (userTextfield) in
            userTextfield.placeholder = "Username"
        }
        alert.addTextField { (textTextfield) in
            textTextfield.placeholder = "Text"
        }

        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let textfields = alert.textFields {
                if !textfields[0].text!.isEmpty && !textfields[1].text!.isEmpty {
                    let post = TextPost(textBody: textfields[1].text,
                                        userName: textfields[0].text!,
                                        timestamp: Date())
                    MediaPostsHandler.shared.addTextPost(textPost: post)
                    self.tableview.reloadData()
                } else {
                    print("You need to fill all the fields")
                }
            }
        }
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MediaPostsHandler.shared.mediaPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = MediaPostsHandler.shared.mediaPosts[indexPath.row]

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
