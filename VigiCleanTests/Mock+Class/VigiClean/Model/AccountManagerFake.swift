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
    var error: Error?
    
    init(resultData: Result<Data, Error>) {
        self.resultData = resultData
        super.init()
    }
    
    init(resultBool: Result<Bool, Error>) {
        self.resultBool = resultBool
        super.init()
    }
    
    init(error: Error?) {
        self.error = error
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
    
    override func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        completion(error)
    }
    
    override func listenForUserDocumentChanges(creditsChanged: ((Int) -> Void)?) {
        guard let creditsChanged = creditsChanged else {
            return
        }
        
        creditsChanged(15)
    }
    
    override func attachEmail(email: String,
                              password: String,
                              completion: @escaping ((Error?) -> Void)) {
        completion(error)
    }
    
    override func updatePseudo(to newPseudo: String, with password: String, completion: @escaping (Error?) -> Void) {
        completion(error)
    }
}
