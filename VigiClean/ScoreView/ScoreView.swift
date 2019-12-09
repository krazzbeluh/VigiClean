//
//  ScoreView.swift
//  VigiClean
//
//  Created by Paul Leclerc on 05/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// TODO: count objects and their types to do a diagram. The number is the user's credit
class ScoreView: UIView, ScoreViewContract {
    var presenter: ScoreViewPresenterContract!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        presenter = ScoreViewPresenter(view: self)
        layer.borderWidth = 25
        layer.cornerRadius = self.frame.width / 2
        presenter.listenForUserCreditChange { newValue in
            self.setScore(to: newValue)
        }
    }
    private var color: UIColor {
        return UIColor(displayP3Red: red, green: green, blue: 0, alpha: 1)
    }
    
    private var red: CGFloat {
        var value: Double = 1
        
        guard let score = score else {
            return 1
        }
        
        if score > 50 {
            value = Double(100 - score) / 50
        }
        return CGFloat(value * 0.85)
    }
    
    private var green: CGFloat {
        var value: Double = 1
        
        guard let score = score else {
            return 0
        }
        
        if score <= 50 {
            value = Double(score) / 50
        }
        return CGFloat(value * 0.85)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var score: Int? {
        guard let scoreText = scoreLabel.text else {
            return nil
        }
        
        guard let score = Int(scoreText) else {
            return nil
        }
        
        return score
    }
    
    func setScore(to score: Int) {
        scoreLabel.text = String(score)
        activityIndicator.isHidden = true
        scoreLabel.isHidden = false
        
        layer.borderColor = color.cgColor
        scoreLabel.textColor = color
    }
}
