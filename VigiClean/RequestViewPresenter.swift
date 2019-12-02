//
//  RequestViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class RequestPresenter: RequestViewPresenter {
    unowned let view: RequestView
    
    required init(view: RequestView) {
        self.view = view
    }
}
