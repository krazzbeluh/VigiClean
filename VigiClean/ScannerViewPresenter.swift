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
    
    var lastCode: String!
    
    required init(view: ScannerView) {
        self.view = view
    }
    
    func verifyCode(code: String) {
        guard code != lastCode else { return }
        lastCode = code
        
        print(code)
        
        if code.starts(with: "https://www.vigiclean.com/") {
            view.startVibration()
            view.validCodeFound()
        } else {
            print("VigiClean KO") // TODO: Display alert: not a vigiclean code
        }
    }
}
