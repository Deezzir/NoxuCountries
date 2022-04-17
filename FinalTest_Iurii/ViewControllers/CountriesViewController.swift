//
//  ViewController.swift
//  FinalTest_Iurii
//
//  Created by Iurii Kondrakov on 2022-04-15.
//

import UIKit

class CountriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Data Source
    var countries:[Country] = []
    //MARK: Variables
    var env:NSDictionary? = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "env", ofType: "plist") {
            env = NSDictionary(contentsOfFile: path)
        } else {
            print("ERROR: Could not find 'env.plist' file")
            return
        }
        
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        
        loadData()
    }
    
    //MARK: Helpers
    private func decodeJSON(data:Data) -> [Country] {
        var items:[Country] = []
        do {
            items = try JSONDecoder().decode([Country].self, from: data)
            print("INFO: Fetched \(items.count) countries from API")
        } catch {
            print("ERROR: Could not decode JSON data")
            print("Error Details: \(error)")
        }
        return items
    }
    
    private func loadData() {
        if(env != nil) {
            let apiEndpoint = env?.object(forKey: "country_api") as! String
            
            guard let apiURL = URL(string: apiEndpoint) else {
                print("ERROR: Could not create API Request URL")
                return
            }
            
            Helper.fetch(from: apiURL) {
                data, response, error in
                if let error = error {
                    print("ERROR: Could not fetch country list")
                    print("Error Details: \(error)")
                    return
                }
                if let data = data {
                    self.countries = self.decodeJSON(data: data)
                    
                    if let country = self.countries.first(where: { $0.name == "Canada" }) {
                        Helper.populationCA = country.population
                        print("INFO: Latest population in Canada: \(country.population)")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let details = storyboard?.instantiateViewController(withIdentifier: "details") as? DetailsViewController else {
            print("ERROR: Could not find Details View Controller")
            return
        }
        
        details.country = countries[indexPath.row]
        self.navigationController?.pushViewController(details, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell     = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country  = countries[indexPath.row]
        
        var content  = cell.defaultContentConfiguration()
        content.text = country.name
        content.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        
        content.secondaryText = "Capital: \(country.capital)"
        content.secondaryTextProperties.font = .systemFont(ofSize: 15)
        
        content.image = UIImage(systemName: "map")
        
        cell.contentConfiguration = content
        return cell
    }
    
}

