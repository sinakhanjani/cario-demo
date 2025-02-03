//
//  DefaultViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 7/26/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerDescriptionLabel: UILabel!
    
    var disaster: Disaster!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // Method
    func updateUI() {
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableView.automaticDimension
        self.headerTitleLabel.text = disaster.title
        self.headerDescriptionLabel.text = disaster.description

    }

}

extension DefaultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disaster.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CONTENT_DEFAULT_CELL, for: indexPath) as! DefaultTableViewCell
        let data = disaster.data[indexPath.row]
        cell.configureCell(subject: data.title, description: data.description)
        
        return cell
    }
    
    
}
