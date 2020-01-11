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
        let docsRef = database.collection("Marketplace")
            .order(by: "partner")
        
        docsRef.getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                if let error = error {
                    completion(ErrorHandler().convertToFirestoreError(error))
                } else {
                    completion(FirebaseInterface.FIRInterfaceError.documentDoesNotExists)
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
    
    func buySale(sale: Sale, complection: @escaping (Error?) -> Void) {
        guard let uid = AccountManager.currentUser.user?.uid else {
            // TODO
            return
        }
        functions.httpsCallable("selectSale?code=\(sale.code)&user=\(uid)")
            .call { (functionResult, error) in
                if let error = error {
                    complection(ErrorHandler().convertToFunctionsError(error))
                    return
                }
                
                // TODO
                guard let data = functionResult?.data as? [String: Any],
                    let code = data["saleCode"] as? String else {
                        return
                }
                
                print(code)
        }
    }
    
    private func getData(data: [String: Any], with code: String) -> Sale? {
        guard let title = data["title"] as? String,
            let littleTitle = data["littleText"] as? String,
            let partner = data["partner"] as? String,
            let description = data["description"] as? String,
            let imageString = data["image"] as? String,
            let imageUrl = URL(string: imageString
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
            let urlString = data["url"] as? String,
            let url = URL(string: urlString),
            let price = data["price"] as? Int else {
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
