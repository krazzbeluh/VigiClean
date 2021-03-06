//
//  AccountManagerFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 25/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
@testable import VigiClean

class AccountManagerFake: AccountManager {
    var resultData: Result<Data, Error>!
    var resultBool: Result<Bool, Error>!
    var errors: [Error?]?
    
    init(resultData: Result<Data, Error>) {
        self.resultData = resultData
        super.init()
    }
    
    init(resultBool: Result<Bool, Error>) {
        self.resultBool = resultBool
        super.init()
    }
    
    init(errors: [Error?]) {
        self.errors = errors
        super.init()
    }
    override init(database: Firestore? = nil, storage: Storage? = nil) {
        let database = FirestoreFake(errors: [nil], datas: nil)
        super.init(database: database, storage: storage)
    }
    
    override func getAvatar(callback: @escaping ((Error?) -> Void)) {
        callback(getError())
    }
    
    override func updateAvatar(from avatar: Data,
                               with password: String,
                               callback: @escaping ((Result<Data, Error>) -> Void)) {
        callback(resultData)
    }
    
    private func getError() -> Error? {
        let error = errors?.first
        errors?.removeFirst()
        return error ?? nil
    }
}
