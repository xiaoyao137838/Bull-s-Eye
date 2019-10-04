//
//  ViewController.swift
//  BullsEye
//
//  Created by Yibeibaoke on 10/3/19.
//  Copyright © 2019 Yibeibaoke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentSliderValue: Int = 50
    var targetValue = 0
    var totalScore = 0
    var totalRound = 0
    var sliderState = SliderState.Incrementing
    var myTimer : Timer?
    
    enum SliderState {
        case Incrementing
        case Decrementing
    }

    @IBOutlet weak var slider_: UISlider!
    @IBOutlet weak var target_value_text_: UILabel!
    @IBOutlet weak var total_score_: UILabel!
    @IBOutlet weak var total_round_: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        renderSlider()
        startNewRound()
    }

    @IBAction func showAlert() {
        myTimer!.invalidate()
        
        let difference = abs(lroundf(slider_.value) - targetValue)
        
        let points = 100 - difference
        
        totalScore += points
        
        let title: String
        if difference == 0 {
            title = "Perfect hit"
        }
        else if difference < 10 {
            title = "You almost did it"
        }
        else if difference < 20 {
            title = "okey dokey"
        }
        else {
            title = "Not even close..."
        }
                
        let message = "You scored: \(points)"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Okay", style: .default, handler: {
            _ in
            self.startNewRound()
        })
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
                    }
    
    @IBAction func sliderMoved(_ slider: UISlider)
    {
        myTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @IBAction func startOver()
    {
        myTimer!.invalidate()
        totalRound = 0
        totalScore = 0
        startNewRound()
        
        // Add the following lines
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name:
                                 CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func startNewRound() {
        targetValue = Int.random(in: 1...100)
        slider_.value = Float(50)
        myTimer =  Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        totalRound += 1
        updateLabels()
    }
    
    func updateLabels() {
      target_value_text_.text = String(targetValue)
      total_score_.text = String(totalScore)
      total_round_.text = String(totalRound)
    }
    
    func renderSlider() {
        let thumbImageNorm = UIImage(named: "SliderThumb-Normal")
        slider_.setThumbImage(thumbImageNorm, for: .normal)
        
        let thumbImageHighlight = UIImage(named: "SliderThumb-Highlighted")
        slider_.setThumbImage(thumbImageHighlight, for: .normal)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable =
                         trackLeftImage.resizableImage(withCapInsets: insets)
        slider_.setMinimumTrackImage(trackLeftResizable, for: .normal)
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable =
                         trackRightImage.resizableImage(withCapInsets: insets)
        slider_.setMaximumTrackImage(trackRightResizable, for: .normal)
    }

    @objc func timerAction() {
        let range =  slider_.maximumValue - slider_.minimumValue
        let increment = range/100

        switch slider_.value {
        case slider_.maximumValue:
            sliderState = .Decrementing
        case slider_.minimumValue:
            sliderState = .Incrementing
        default:
            break
        }

        switch sliderState {
        case .Incrementing:
            slider_.setValue(slider_.value + increment, animated: true)
        case .Decrementing:
            slider_.setValue(slider_.value - increment, animated: true)
        }
    }
}

