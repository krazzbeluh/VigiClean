//
//  ScannerViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ScannerPresenter: ScannerViewPresenter {
    unowned let view: ScannerView
    
    required init(view: ScannerView) {
        self.view = view
    }
}
