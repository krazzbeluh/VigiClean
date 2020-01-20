//
//  Sale.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

// A sale is a promotional offer. It congrats users to contribute to project
struct Sale {
    let price: Int
    let image: URL
    let title: String
    let littleTitle: String
    let partner: String
    let description: String
    let code: String
}
