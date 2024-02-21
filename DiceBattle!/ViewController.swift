//
//  ViewController.swift
//  DiceBattle!
//
//  Created by Warat Poovorakit on 22/2/2567 BE.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var diceImageBlue1: UIImageView!
    @IBOutlet weak var diceImageRed1: UIImageView!
    @IBOutlet weak var diceImageBlue2: UIImageView!
    @IBOutlet weak var diceImageRed2: UIImageView!
    
    var timer: Timer?
    var counter = 0
    
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rollButton.isHidden = false
        resetButton.isHidden = false
    }
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        resetButton.isHidden = true
        rollButton.isHidden = true
        counter = 0
        
        setFinalBottomDiceImages()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(rollBottomDice), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.rollTopDice), userInfo: nil, repeats: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.timer?.invalidate()
                
                // Display winner after both sets of dice have been rolled
                self.showToast(message: self.getWinner())
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.rollButton.isHidden = false
                    self.resetButton.isHidden = false
                }
            }
        }
    }


    @objc func rollTopDice() {
        counter += 1
        setFinalTopDiceImages()
    }

    @objc func rollBottomDice() {
        counter += 1
        setFinalBottomDiceImages()
    }
    
    
    func getWinner() -> String {
        let finalNames = self.getFinalDiceImages()
        
        // Extract the last character from each dice image name and convert to integers
        let firstRedDiceValue = Int(String(finalNames[0].last ?? "0")) ?? 0
        let firstBlueDiceValue = Int(String(finalNames[1].last ?? "0")) ?? 0
        let secondRedDiceValue = Int(String(finalNames[2].last ?? "0")) ?? 0
        let secondBlueDiceValue = Int(String(finalNames[3].last ?? "0")) ?? 0
        
        // Calculate the total values for red and blue dice
        let totalRedValue = firstRedDiceValue + secondRedDiceValue
        let totalBlueValue = firstBlueDiceValue + secondBlueDiceValue
        
        // Compare total values to determine the winner
        if totalRedValue > totalBlueValue {
            return "Red wins!"
        } else if totalRedValue < totalBlueValue {
            return "Blue wins!"
        } else {
            return "It's a tie!"
        }
    }

    
    func getFinalDiceImages() -> [String] {
        let redDice1Name = diceImageRed1.image?.accessibilityIdentifier ?? ""
        let blueDice1Name = diceImageBlue1.image?.accessibilityIdentifier ?? ""
        let redDice2Name = diceImageRed2.image?.accessibilityIdentifier ?? ""
        let blueDice2Name = diceImageBlue2.image?.accessibilityIdentifier ?? ""
        
        return [redDice1Name, blueDice1Name, redDice2Name, blueDice2Name]
    }

    func setFinalBottomDiceImages() {
        let randomRedDice1 = getRandomRedDiceImageName()
        let randomBlueDice1 = getRandomBlueDiceImageName()

        diceImageRed1.image = UIImage(named: randomRedDice1)
        diceImageBlue1.image = UIImage(named: randomBlueDice1)

        diceImageRed1.image?.accessibilityIdentifier = randomRedDice1
        diceImageBlue1.image?.accessibilityIdentifier = randomBlueDice1

    }
    func setFinalTopDiceImages(){
        let randomRedDice2 = getRandomRedDiceImageName()
        let randomBlueDice2 = getRandomBlueDiceImageName()
        
        diceImageRed2.image = UIImage(named: randomRedDice2)
        diceImageBlue2.image = UIImage(named: randomBlueDice2)
        
        diceImageRed2.image?.accessibilityIdentifier = randomRedDice2
        diceImageBlue2.image?.accessibilityIdentifier = randomBlueDice2
    }

    
    func getRandomRedDiceImageName() -> String {
        let diceImageArrayRed = ["reddice1", "reddice2", "reddice3", "reddice4", "reddice5", "reddice6"]
        return diceImageArrayRed.randomElement()!
    }
    
    func getRandomBlueDiceImageName() -> String{
        let diceImageArrayBlue = ["bluedice1", "bluedice2", "bluedice3", "bluedice4", "bluedice5", "bluedice6"]
        return diceImageArrayBlue.randomElement()!
    }
    

    
    func showToast(message: String, duration: TimeInterval = 7.5) {
        let maxSize = CGSize(width: self.view.frame.size.width - 40, height: self.view.frame.size.height - 80)
        
        let toastLabel = UILabel()
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 45)
        toastLabel.text = message
        
        let expectedSize = toastLabel.sizeThatFits(maxSize)
        let toastWidth = min(expectedSize.width + 20, self.view.frame.size.width - 40)
        let toastHeight = min(expectedSize.height + 20, self.view.frame.size.height - 80)
        
        toastLabel.frame = CGRect(x: (self.view.frame.size.width - toastWidth) / 2,
                                  y: self.view.frame.size.height - toastHeight - 50, // Adjusted y-coordinate for bottom placement
                                  width: toastWidth,
                                  height: toastHeight)
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }

}



