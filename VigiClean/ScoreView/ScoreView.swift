//
//  ScoreView.swift
//  VigiClean
//
//  Created by Paul Leclerc on 05/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// ScoreView displays user score with calculated color
class ScoreView: UIView, ScoreViewContract {
    var presenter: ScoreViewPresenterContract!
    
    override func layoutSubviews() { // making view circular
        super.layoutSubviews()
        presenter = ScoreViewPresenter(view: self)
        layer.borderWidth = 25
        layer.cornerRadius = self.frame.width / 2
        
        presenter.getScore()
    }
    
    private var color: UIColor {  // stores view color
        let color = presenter.getColorCode(for: score ?? 0)
        return UIColor(displayP3Red: CGFloat(color.red),
                       green: CGFloat(color.green),
                       blue: CGFloat(color.blue),
                       alpha: CGFloat(color.alpha))
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    private var score: Int? {
        guard let scoreText = scoreLabel.text else {
            return nil
        }
        
        guard let score = Int(scoreText) else {
            return nil
        }
        
        return score
    }
    
    func setScore(to score: Int) { // Sets score display
        scoreLabel.text = String(score)
        scoreLabel.isHidden = false
        
        layer.borderColor = color.cgColor
        scoreLabel.textColor = color
    }
    
    func scoreValueChanged(to value: Int) { // updates view on score modification
        setScore(to: value)
    }
}
