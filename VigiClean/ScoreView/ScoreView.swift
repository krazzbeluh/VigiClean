//
//  ScoreView.swift
//  VigiClean
//
//  Created by Paul Leclerc on 05/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// TODO: get objects and their types to do a diagram with good and bad requests. The number is the user's credit
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
        let color = presenter.getColorCode(for: score ?? 0)
        return UIColor(displayP3Red: CGFloat(color.red),
                       green: CGFloat(color.green),
                       blue: CGFloat(color.blue),
                       alpha: CGFloat(color.alpha))
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
