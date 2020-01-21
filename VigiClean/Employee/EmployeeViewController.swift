//
//  EmployeeViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 08/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

// EmployeeView is a view that lets employee to manage requested objects
class EmployeeViewController: UIViewController, EmployeeView {
    var presenter: EmployeeViewPresenter!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var didmissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = EmployeePresenter(view: self)
        
        presenter.getObjectList()
    }
    
    func reloadTableView() { // reloads tableView on modification
        tableView.reloadData()
    }
}

extension EmployeeViewController: UITableViewDataSource { // manages tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let objects = presenter.objects else {
            return 0
        }
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.object.rawValue,
                                                       for: indexPath) as? ObjectTableViewCell else {
            return UITableViewCell()
        }
        
        guard let objects = presenter.objects else {
            return UITableViewCell()
        }
        
        let object = objects[indexPath.row]
        
        cell.configure(for: object)
        
        return cell
    }
}
