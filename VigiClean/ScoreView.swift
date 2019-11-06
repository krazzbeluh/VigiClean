//
//  ScoreView.swift
//  VigiClean
//
//  Created by Paul Leclerc on 05/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class ScoreView: UIView {
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
    private var score: Int? {
        guard let scoreText = scoreLabel.text else {
            return nil
        }
        
        guard let score = Int(scoreText) else {
            return nil
        }
        
        return score
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 25
        layer.cornerRadius = self.frame.width / 2
        layer.borderColor = color.cgColor
        scoreLabel.textColor = color
        
        /*DispatchQueue.global(qos: .background).async {
            while true {
                if let text = readLine() {
                    print(text)
                    DispatchQueue.main.async {
                        self.scoreLabel.text = text
                    }
                }
            }
        }*/
    }

}
