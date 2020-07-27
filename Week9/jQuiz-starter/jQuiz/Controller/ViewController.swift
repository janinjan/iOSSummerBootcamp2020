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
        displayLogo()
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
        network.getRandomCategory { (success, category) in
            if let id = category, success {
                let categoryID = id[0].categoryID
                self.network.getAllCluesInCategory(categoryID: categoryID ) { (success, clues) in
                    if let clues = clues, success {
                        DispatchQueue.main.async {
                            self.clues = Array(clues.prefix(4))
                            self.updateUI()
                        }
                    }
                }
            } else {
                print("no data")
            }
        }
    }

    private func updateUI() {
        let randomClue = clues.randomElement()
        self.correctAnswerClue = randomClue

        clueLabel.text = correctAnswerClue?.question
        categoryLabel.text = correctAnswerClue?.category.title
        scoreLabel.text = "\(points)"
        tableView.reloadData()
    }

    private func changeQuestion() {
        getClues()
    }

    private func displayLogo() {
        guard let imageUrl = URL(string: "https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg") else {
            return
        }
        logoImageView.setImage(with: imageUrl)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clues.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = clues[indexPath.row].answer
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnswer = clues[indexPath.row]
        let selectedCell = tableView.cellForRow(at: indexPath)
        let backgroundView = UIView()
        selectedCell?.selectedBackgroundView = backgroundView

        guard let correct = correctAnswerClue else { return }
        if selectedAnswer.answer.contains(correct.answer) {
            points += correct.points ?? 0
            backgroundView.backgroundColor = UIColor.green
        } else {
            backgroundView.backgroundColor = UIColor.red
        }
        DispatchQueue.main.async {
            self.changeQuestion()
        }
    }
}
