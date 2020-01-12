//
//  MarketplaceManager.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFunctions

class MarketplaceManager {
    var database: Firestore
    var storage: Storage
    var functions: Functions
    
    static var sales = [Sale]()
    
    init() {
        database = Firestore.firestore()
        storage = Storage.storage()
        functions = Functions.functions()
    }
    
    func getSales(completion: @escaping (Error?) -> Void) {
        let docsRef = database.collection(FirestoreCollection.marketplace.rawValue)
            .order(by: FirestoreCollection.FirestoreField.partner.rawValue)
        
        docsRef.getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                if let error = error {
                    completion(ErrorHandler().convertToFirestoreError(error))
                } else {
                    completion(FirebaseInterfaceError.documentDoesNotExists)
                }
                return
            }
            
            var sales = [Sale]()
            
            print(querySnapshot.documents.count)
            for document in querySnapshot.documents {
                guard let sale = self.getData(data: document.data(), with: document.documentID) else {
                    break
                }
                sales.append(sale)
            }
            
            MarketplaceManager.sales = sales
            completion(nil)
        }
    }
    
    func buySale(sale: Sale, complection: @escaping (Result<String, Error>) -> Void) {
        guard let uid = VigiCleanUser.currentUser.user?.uid else {
            complection(.failure(AccountManager.UAccountError.userNotLoggedIn))
            return
        }
        functions.httpsCallable("selectSale?code=\(sale.code)&user=\(uid)")
            .call { (functionResult, error) in
                if let error = error {
                    complection(.failure(ErrorHandler().convertToFunctionsError(error)))
                    return
                }
                
                guard let data = functionResult?.data as? [String: Any],
                    let code = data[FunctionsFields.saleCode.rawValue] as? String else {
                        return
                }
                
                complection(.success(code))
        }
    }
    
    private func getData(data: [String: Any], with code: String) -> Sale? {
        guard let title = data[FirestoreCollection.FirestoreField.title.rawValue] as? String,
            let littleTitle = data[FirestoreCollection.FirestoreField.littleText.rawValue] as? String,
            let partner = data[FirestoreCollection.FirestoreField.partner.rawValue] as? String,
            let description = data[FirestoreCollection.FirestoreField.description.rawValue] as? String,
            let imageString = data[FirestoreCollection.FirestoreField.image.rawValue] as? String,
            let imageUrl = URL(string: imageString
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
            let urlString = data[FirestoreCollection.FirestoreField.url.rawValue] as? String,
            let url = URL(string: urlString),
            let price = data[FirestoreCollection.FirestoreField.price.rawValue] as? Int else {
                return nil
        }
        
        return Sale(price: price,
                    image: imageUrl,
                    title: title,
                    littleTitle: littleTitle,
                    partner: partner,
                    description: description,
                    url: url,
                    code: code)
    }
}
