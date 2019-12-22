//
//  ScannerViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ScannerPresenter: BasePresenter, ScannerViewPresenter {
    weak var view: ScannerView!
    
    var lastCode: String!
    
    let objectManager = ObjectManager()
    
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
            objectManager.getObject(code: objectCode) { result in
                switch result {
                case .success:
                    self.view.validObjectFound()
                case .failure(let error):
                    self.view.invalidCodeFound(error: error)
                }
            }
        } else {
            view.invalidCodeFound(error: Scanner.ScannerError.invalidQRCode)
        }
    }
}
