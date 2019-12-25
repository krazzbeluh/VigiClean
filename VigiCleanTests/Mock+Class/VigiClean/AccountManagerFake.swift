//
//  AccountManagerFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 25/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class AccountManagerFake: AccountManager {
    var result: Result<Data, Error>
    
    init(result: Result<Data, Error>) {
        self.result = result
        super.init()
    }
    
    override func getAvatar(callback: @escaping ((Result<Data, Error>) -> Void)) {
        callback(result)
    }
}
