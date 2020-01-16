//
//  FakeScoreView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeScoreView: ScoreViewContract {
    var didCallValueChanged = false
    
    func scoreValueChanged(to value: Int) {
        self.didCallValueChanged = true
    }
}
