//
//  DetailsViewController.swift
//  FinalTest_Iurii
//
//  Created by Iurii Kondrakov on 2022-04-15.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var imageView:       UIImageView!
    @IBOutlet weak var countryLabel:    UILabel!
    @IBOutlet weak var capitalLabel:    UILabel!
    @IBOutlet weak var codeLabel:       UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    
    @IBOutlet var errorView:        UIView!
    @IBOutlet weak var detailsVIew: UIView!
    @IBOutlet weak var buttonView:  UIView!
    
    //MARK: CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: Variables
    var country:Country? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
    }
    
    //MARK: Actions
    @IBAction func addPressed(_ sender: Any) {
        if let country = country {
            let request:NSFetchRequest = Favourite.fetchRequest()
            request.predicate  = NSPredicate(format: "name == %@", country.name)
            request.fetchLimit = 1
            
            //Check if exists and add to favourites
            do {
                if (try context.fetch(request)).count == 0 {
                    let favourite = Favourite(context: context)
                    favourite.population = country.population
                    favourite.name       = country.name
                    
                    try context.save()
                    showAlert(message: "Added to Favourites", ok: true)
                } else {
                    showAlert(message: "Already in Favourites", ok: false)
                }
            } catch {
                print("ERROR: Could not fetch request from CoreData")
                showAlert(message: "Could not add to Favourites", ok: false)
            }
        }
    }
    
    //MARK: Helpers
    private func showAlert(message: String, ok:Bool) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let action          = ok ? UIAlertAction(title: "OK", style: .default) : UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }
    
    private func setData() {
        var switched:Bool = true
        if let country = country {
            countryLabel.text     = country.name
            capitalLabel.text     = country.capital
            codeLabel.text        = country.code
            populationLabel.text  = String(country.population)
            
            getImage(country.flagSrc)
            
            switched = false
        }
        
        detailsVIew.isHidden = switched
        buttonView.isHidden  = switched
        errorView.isHidden   = !switched
    }
    
    private func getImage(_ url:String) {
        guard let imgUrl = URL(string: url) else {
            print("ERROR: Could not create the Image URL")
            return
        }
                
        Helper.fetch(from: imgUrl) { (data, response, error) -> () in
            if let error = error {
                print("ERROR: Could not fetch the flag image")
                print("Error Details: \(error)")
                return
            }
            if let data = data {
                print("INFO: Fetched the flag image for \(self.country?.name ?? "N/A")")
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}
