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
    var selectedAnswer: ClueElement?
    var correctAnswerClue: ClueElement?
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
                        self.fourCLuesList = Array(clues.prefix(4))
//                        print(self.fourCLuesList)
                        self.updateUI()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    private func updateUI() {
        categoryLabel.text = fourCLuesList[0].category.title
        let randomClue = fourCLuesList.randomElement()
        clueLabel.text = randomClue?.question
        self.correctAnswerClue = randomClue
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnswer = fourCLuesList[indexPath.row]
        guard let correct = correctAnswerClue else { return }
        if selectedAnswer.answer.contains(correct.answer) {
            print("ok")
        } else {
            print("wrong answer")
        }
    }
}

