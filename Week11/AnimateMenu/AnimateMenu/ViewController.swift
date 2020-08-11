//
//  ViewController.swift
//  AnimateMenu
//
//  Created by Janin Culhaoglu on 08/08/2020.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private var menuButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var person: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!

    @IBOutlet weak var personBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonOneTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTwoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonThreeTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var isMenuOpen = false
    var circleViewCenter: CGPoint!
    var animator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        circleView.layer.cornerRadius = circleView.frame.width/2

        buttonOneTrailingConstraint.constant = -20
        buttonTwoBottomConstraint.constant = -20
        buttonThreeTrailingConstraint.constant = -20

        backgroundImageView.layer.cornerRadius = 20
        informationLabel.layer.cornerRadius = 15
        informationLabel.layer.masksToBounds = true

        buttonOne.alpha = 0
        buttonTwo.alpha = 0
        buttonThree.alpha = 0

        animator = UIViewPropertyAnimator.init(duration: 5.0, curve: .easeInOut)
    }

    // MARK: - Actions
    @IBAction func toggleMenu(_ sender: UIButton) {
        isMenuOpen.toggle()

        if menuButton.currentBackgroundImage == UIImage(systemName: "play.circle.fill") {
            animator.startAnimation()
            animator.addCompletion { position in
                switch position {
                case .end:
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, animations: {
                        self.personBottomConstraint.constant = -155
                        self.person.alpha = 1
                        self.person.transform = .identity
                        self.view.layoutIfNeeded()
                    })
                case .start:
                    break
                case .current:
                    break
                @unknown default:
                    break
                }
            }
        }

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            let menuConstraint: CGFloat = self.isMenuOpen ? 20 : -90
            self.buttonOneTrailingConstraint.constant = menuConstraint
            self.buttonTwoBottomConstraint.constant = menuConstraint
            self.buttonThreeTrailingConstraint.constant = menuConstraint
            self.view.layoutIfNeeded()
            
            self.buttonOne.alpha = self.isMenuOpen ? 1 : 0
            self.buttonTwo.alpha = self.isMenuOpen ? 1 : 0
            self.buttonThree.alpha = self.isMenuOpen ? 1 : 0
            self.circleView.alpha = self.isMenuOpen ? 0.5 : 0

            self.menuButton.transform = .init(scaleX: self.isMenuOpen ? 0.8 : 1, y: self.isMenuOpen ? 0.8 : 1)
            self.circleView.transform = .init(scaleX: self.isMenuOpen ? 1 : 0.1, y: self.isMenuOpen ? 1 : 0.1)
            self.menuButton.setBackgroundImage(UIImage(systemName: self.isMenuOpen ? "play.circle.fill" : "plus.circle.fill"), for: .normal)
        })
    }

    @IBAction func lightButtonTapped(_ sender: UIButton) {
        animateInformationLabel()
        animator.addAnimations {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
                self.person.alpha = 0.5
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func moveUpButtonTapped(_ sender: UIButton) {
        animateInformationLabel()
        animator.addAnimations {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
                self.personBottomConstraint.constant = -220
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func scaleButtonTapped(_ sender: UIButton) {
        animateInformationLabel()
        animator.addAnimations {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
                self.person.transform = .init(scaleX: 0.8, y: 0.8)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    private func animateInformationLabel() {
        informationLabel.alpha = 0
        UIView.animate(withDuration: 0.45) {
            self.informationLabel.alpha = 0.9
        }

        delay(seconds: 1) {
            UIView.animate(withDuration: 0.45) {
                self.informationLabel.alpha = 0
            }
        }
    }

    private func assignbackground() {
        let background = UIImage(named: "violetRectangle")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
    }
}
