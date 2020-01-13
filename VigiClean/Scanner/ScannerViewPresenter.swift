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
    
    var objectManager = ObjectManager()
    
    var objectCode: String {
        return lastCode.replacingOccurrences(of: "https://www.vigiclean.com/?code=", with: "")
    }
    
    required init(view: ScannerView) {
        self.view = view
    }
    
    init(view: ScannerView, objectManager: ObjectManager) {
        self.view = view
        self.objectManager = objectManager
    }
    
    func verifyCode(code: String) {
        guard code != lastCode else { return }
        lastCode = code
        
        if code.starts(with: "https://www.vigiclean.com/") {
            view.correctCodeFound()
        } else {
            invalidCodeFound(error: ScannerError.invalidQRCode)
        }
    }
    
    func getObject() {
        objectManager.getObject(code: objectCode) { result in
            switch result {
            case .success(let object):
                self.objectManager.getActions(for: object) { (result) in
                    switch result {
                    case .success:
                        self.objectManager.getEmployeeActions(for: object) { (result) in
                            switch result {
                            case .success:
                                self.view.validObjectFound()
                            case .failure(let error):
                                self.invalidCodeFound(error: error)
                            }
                        }
                    case .failure(let error):
                        self.invalidCodeFound(error: error)
                    }
                }
            case .failure(let error):
                self.invalidCodeFound(error: error)
            }
        }
    }
    
    private func invalidCodeFound(error: Error) {
        lastCode = ""
        if !view.isAlreadyPresentingAlert { // TODO : Ask to Nicolas : not testable ; will always return true in tests
            view.invalidCodeFound(error: error)
        }
    }
}
