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
    var pickedImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        MediaPostsHandler.shared.getPosts()
    }

    private func setUpTableView() {
        // Set delegates, register custom cells, set up datasource, etc.
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        tableview.register(CustomTextCell.nib(), forCellReuseIdentifier: CustomTextCell.identifier)
        tableview.register(CustomImageAndTextCell.nib(), forCellReuseIdentifier: CustomImageAndTextCell.identifier)
        tableview.allowsSelection = false
    }

    @IBAction func didPressCreateTextPostButton(_ sender: Any) {
       displayPostAlert()
    }

    @IBAction func didPressCreateImagePostButton(_ sender: Any) {
        displayImagePicker()
    }

    /**
     * Get image from Photo Library or from camera if the first isn't possible.
     */
    private func displayImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.sourceType = .photoLibrary
        } else {
            picker.sourceType = .camera
            picker.modalPresentationStyle = .fullScreen
        }
        present(picker, animated: true, completion: nil)
    }

    private func displayPostAlert() {
        let alert = UIAlertController(title: "Create Post", message: "What's up? :]", preferredStyle: .alert)

        alert.addTextField { (userTextfield) in
            userTextfield.placeholder = "Username"
        }
        alert.addTextField { (textTextfield) in
            textTextfield.placeholder = "Text"
        }

        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let textfields = alert.textFields {
                guard let userText = textfields[0].text else { return }
                guard let bodyText = textfields[1].text else { return }
                
                if !userText.isEmpty && !bodyText.isEmpty {
                    if self.pickedImage.image != nil {
                        let post = ImagePost(textBody: bodyText,
                                             userName: userText,
                                             timestamp:  Date(),
                                             image: self.pickedImage.image!)
                        MediaPostsHandler.shared.addImagePost(imagePost: post)
                        self.pickedImage.image = nil
                    } else {
                        let post = TextPost(textBody: bodyText,
                                            userName: userText,
                                            timestamp: Date())
                        MediaPostsHandler.shared.addTextPost(textPost: post)
                    }
                    self.tableview.reloadData()
                } else {
                    print("You need to fill all the fields.")
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

extension ViewController: UITableViewDelegate {}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        self.pickedImage.image = pickedImage
        
        dismiss(animated: true, completion: {
            self.displayPostAlert()
        })
    }
   
}
