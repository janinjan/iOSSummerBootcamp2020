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
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var person: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var personBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var isMenuOpen = false
    var buttonOneCenter: CGPoint!
    var buttonTwoCenter: CGPoint!
    var buttonThreeCenter: CGPoint!
    var circleViewCenter: CGPoint!
    var animator: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        circleView.layer.cornerRadius = circleView.frame.width/2
        buttonOneCenter = buttonOne.center
        buttonTwoCenter = buttonTwo.center
        buttonThreeCenter = buttonThree.center
        
        buttonOne.center = menuButton.center
        buttonTwo.center = menuButton.center
        buttonThree.center = menuButton.center

        circleView.layer.zPosition = -1
        backgroundImageView.layer.cornerRadius = 20
        informationLabel.layer.cornerRadius = 15
        informationLabel.layer.masksToBounds = true
        
        animator = UIViewPropertyAnimator.init(duration: 5.0, curve: .easeInOut)
    }

    // MARK: - Actions
    @IBAction func toggleMenu(_ sender: UIButton) {
        isMenuOpen.toggle()

        if menuButton.currentBackgroundImage == UIImage(systemName: "play.circle.fill") {
            animator.startAnimation()
        }

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            self.buttonOne.center =  self.isMenuOpen ? self.buttonOneCenter : self.menuButton.center
            self.buttonTwo.center = self.isMenuOpen ? self.buttonTwoCenter : self.menuButton.center
            self.buttonThree.center = self.isMenuOpen ? self.buttonThreeCenter : self.menuButton.center

            self.buttonOne.alpha = self.isMenuOpen ? 1 : 0
            self.buttonTwo.alpha = self.isMenuOpen ? 1 : 0
            self.buttonThree.alpha = self.isMenuOpen ? 1 : 0
            self.circleView.alpha = self.isMenuOpen ? 0.5 : 0

            self.menuButton.transform = .init(scaleX: self.isMenuOpen ? 0.8 : 1, y: self.isMenuOpen ? 0.8 : 1)
            self.circleView.transform = .init(scaleX: self.isMenuOpen ? 1 : 0.1, y: self.isMenuOpen ? 1 : 0.1)
            self.menuButton.setBackgroundImage(UIImage(systemName: self.isMenuOpen ? "play.circle.fill" : "plus.circle.fill"), for: .normal)
        })
    }

    @IBAction func squareButtonTapped(_ sender: UIButton) {
        animateInformationLabel()
    }

    @IBAction func rotateButtonTapped(_ sender: UIButton) {
        animateInformationLabel()
        animator.addAnimations {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
                self.personBottomConstraint.constant = 200
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func moveToRightButtonTapped(_ sender: UIButton) {
        animateInformationLabel()
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
