//
//  ScoreContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol ScoreViewPresenterContract {
    init(view: ScoreViewContract)
    func listenForUserCreditChange(valueChanged: @escaping (Int) -> Void)
    func getColorCode(for score: Int) -> Color
}

protocol ScoreViewContract: class {
    
}
