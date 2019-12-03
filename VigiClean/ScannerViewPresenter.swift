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
    
    var objectCode: String {
        return lastCode.replacingOccurrences(of: "https://www.vigiclean.com/?code=", with: "")
    }
    
    required init(view: ScannerView) {
        self.view = view
    }
    
    func verifyCode(code: String) {
        guard code != lastCode else { return }
        lastCode = code
        
        if code.starts(with: "https://www.vigiclean.com/") {
            view.startVibration()
            
            view.displayLoadViews(true)
            Object.getObject(code: objectCode) { error in
                if let error = error {
                    self.view.invalidCodeFound(error: error)
                    return
                }
                
                self.view.validObjectFound()
            }
        } else {
            view.invalidCodeFound(error: UserAccount.UAccountError.notMatchingPassword) // TODO: use valid error
        }
    }
}
