//
//  RequestViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 26/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, RequestView {
    
    var presenter: RequestViewPresenter!
    
    // MARK: Properties
    var object: Object!

    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var grayOutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = RequestPresenter(view: self)
        
        guard object != nil else {
            fatalError("No code in requestVC !")
        }
    }
    
    func loading(grayed: Bool) {
        activityIndicator.isHidden = !grayed
        grayOutView.isHidden = !grayed
    }
}
