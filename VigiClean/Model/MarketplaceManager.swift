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

class MarketplaceManager {
    var database: Firestore
    var storage: Storage
    
    static var sales = [Sale]()
    
    init() {
        database = Firestore.firestore()
        storage = Storage.storage()
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
                guard let sale = self.getData(data: document.data()) else {
                    break
                }
                sales.append(sale)
            }
            
            MarketplaceManager.sales = sales
            completion(nil)
        }
    }
    
    private func getData(data: [String: Any]) -> Sale? {
        guard let title = data["title"] as? String,
            let littleTitle = data["littleText"] as? String,
            let partner = data["partner"] as? String,
            let description = data["description"] as? String,
            let imageString = data["image"] as? String,
            let imageUrl = URL(string: imageString
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
            let urlString = data["url"] as? String,
            let url = URL(string: urlString) else {
                return nil
        }
        
        return Sale(image: imageUrl,
                    title: title,
                    littleTitle: littleTitle,
                    partner: partner,
                    description: description,
                    url: url)
    }
}
