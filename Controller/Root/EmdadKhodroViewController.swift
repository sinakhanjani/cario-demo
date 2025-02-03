//
//  EmdadKhodroViewController.swift
//  Cario
//
//  Created by Sinakhanjani on 8/1/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class EmdadKhodroViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var titleHeader: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        self.title = titleHeader
    }
    

}

extension EmdadKhodroViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Emdad.emdads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EMDAD_KHODRO_CELL, for: indexPath) as! EmdadKhodroTableViewCell
        let emdad = Emdad.emdads[indexPath.row]
        cell.configureCell(image: UIImage.init(named: "services_emdad")!, name: emdad.name, tel: emdad.tel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emdad = Emdad.emdads[indexPath.row]
        let telURL = "tel://\(emdad.tel)"
        if let url = URL(string: telURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
