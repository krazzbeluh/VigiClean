//
//  ScannerContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol ScannerViewPresenter: BasePresenter {
    init(view: ScannerView)
    
    var objectCode: String { get }
    
    func verifyCode(code: String)
    func getObject()
}

protocol ScannerView: BaseView {
    func correctCodeFound()
    func validObjectFound()
    func invalidCodeFound(error: Error)
}
