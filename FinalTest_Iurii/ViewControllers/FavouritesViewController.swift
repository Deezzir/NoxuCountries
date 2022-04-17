//
//  FavouritesViewController.swift
//  FinalTest_Iurii
//
//  Created by Iurii Kondrakov on 2022-04-15.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Outlets
    @IBOutlet weak var errorView:      UIView!
    @IBOutlet weak var tableView:      UITableView!
    @IBOutlet weak var favouritesView: UIView!
    
    //MARK: CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: Data Source
    var favourites:[Favourite] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favourites = loadData()
        var switched:Bool = true
        
        if favourites.count > 0 {
            tableView.reloadData()
            switched = false
        }
        
        favouritesView.isHidden = switched
        errorView.isHidden      = !switched
    }
    
    //MARK: Helpers
    private func loadData() -> [Favourite] {
        var items:[Favourite] = []
        let request:NSFetchRequest<Favourite> = Favourite.fetchRequest()
        do {
            items = try context.fetch(request)
            print("INFO: Fetched \(items.count) countries from CoreData")
        } catch {
            print("ERROR: Could not fetch favourites from CoreData")
        }
        return items
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = favourites[indexPath.row]
        
        cell.backgroundColor = item.population > Helper.populationCA ? UIColor(red: 0.9, green: 0.96, blue: 0.97, alpha: 1.0) : UIColor.white
        
        var content  = cell.defaultContentConfiguration()
        content.text = item.name
        content.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        
        content.secondaryText = "Population: \(item.population)"
        content.secondaryTextProperties.font = .systemFont(ofSize: 15)
                
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                print("INFO: Deleting \(favourites[indexPath.row].name ?? "N/A") from Favourites")

                context.delete(favourites[indexPath.row])
                try context.save()
                        
                favourites.remove(at:indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("ERROR: Could not delete favourite from CoreData")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
