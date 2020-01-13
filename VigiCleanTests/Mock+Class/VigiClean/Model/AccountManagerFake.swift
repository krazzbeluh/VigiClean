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
    
    override init() {
        let auth = AuthFake(error: nil, result: nil)
        let database = FirestoreFake(errors: [nil], datas: nil)
        super.init(auth: auth, database: database)
    }
    
    override func getAvatar(callback: @escaping ((Error?) -> Void)) {
        callback(getError())
    }
    
    override func listenForUserDocumentChanges(creditsChanged: ((Int) -> Void)?) {
        guard let creditsChanged = creditsChanged else {
            return
        }
        
        creditsChanged(15)
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
