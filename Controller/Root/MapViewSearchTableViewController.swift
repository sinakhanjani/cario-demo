//
//  MapViewSearchTableViewController.swift
//  Cario
//
//  Created by Teodik Abrami on 10/21/18.
//  Copyright © 2018 iPersianDeveloper. All rights reserved.
//

import UIKit

class MapViewSearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var predictions: [Prediction]?
    weak var handleMapSearchDelegate: HandleMapSearch?
    
    func updateSearchResults(for searchController: UISearchController) {
        getJson(searchedText: searchController.searchBar.text)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getJson(searchedText: String?) {
        guard let searchedText = searchedText else { return }
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchedText)&inputtype=textquery&key=AIzaSyAf0sKw2uMrV9n8r28Dz-AYc4T5-ctnQ8k&language=fa".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) else { return }
        let request = URLRequest.init(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
            }
            guard let data = data else { return }
            guard let decodedJson = try? JSONDecoder().decode(GoogleSearch.self, from: data) else { return }
            self.predictions = decodedJson.predictions
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }.resume()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let predictions = self.predictions, !predictions.isEmpty {
            return predictions.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MAP_SEARCH_CELL_ID, for: indexPath)
        if let predictions = self.predictions, !predictions.isEmpty {
            cell.textLabel?.text = predictions[indexPath.row].description
            return cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let prediction = self.predictions else { return }
        handleMapSearchDelegate?.searchBarSelectedItem(prediction[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
