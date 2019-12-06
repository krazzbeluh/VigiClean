//
//  SignInContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 20/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import UIKit

protocol SignInViewPresenter {
    init(view: SignInView)
    func signIn(email: String?, password: String?)
}

protocol SignInView: class {
    var activityIndicator: UIActivityIndicatorView! { get set }
    func sendAlert(message: String)
    func userSignedIn()
    func switchActivityIndicator(hidden: Bool)
}
