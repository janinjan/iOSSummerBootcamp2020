//
//  ViewController.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!

    var clues: [ClueElement] = []
    var fourCLuesList: [ClueElement] = []
    var correctAnswerClue: Clue?
    var points: Int = 0
    let network = Networking()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        getClues()
        
        self.scoreLabel.text = "\(self.points)"

        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }

        SoundManager.shared.playSound()
        
    }

    @IBAction func didPressVolumeButton(_ sender: Any) {
        SoundManager.shared.toggleSoundPreference()
        if SoundManager.shared.isSoundEnabled == false {
            soundButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
    }

    private func getClues() {
        network.getRandomCategory { (success, categoryID) in
            if let id = categoryID, success {
                let id = id[0].category.id
                self.network.getAllCluesInCategory(categoryID: id) { (success, clues) in
                    if let clues = clues, success {
                        self.clues = clues
                        self.fourCLuesList = clues.enumerated().compactMap{ $0 < 4 ? $1 : nil }
                        self.updateUI()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    private func updateUI() {
        let shuffledClues = fourCLuesList.shuffled()
        categoryLabel.text = fourCLuesList[0].category.title
        clueLabel.text = shuffledClues[0].question
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fourCLuesList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fourCLuesList[indexPath.row].answer
//        print(firstFourClues)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

