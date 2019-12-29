//
//  AccountManagerFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 25/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
@testable import VigiClean

class AccountManagerFake: AccountManager {
    var resultData: Result<Data, Error>!
    var resultBool: Result<Bool, Error>!
    
    init(resultData: Result<Data, Error>) {
        self.resultData = resultData
        super.init()
    }
    
    init(resultBool: Result<Bool, Error>) {
        self.resultBool = resultBool
        super.init()
    }
    
    override init() {
        let auth = AuthFake(error: nil, result: nil)
        let database = FirestoreFake(error: nil)
        super.init(auth: auth, database: database)
    }
    
    override func getAvatar(callback: @escaping ((Result<Data, Error>) -> Void)) {
        callback(resultData)
    }
    
    override func fetchRole(callback: @escaping (Result<Bool, Error>) -> Void) {
        callback(resultBool)
    }
}
