//
//  MealListTableViewController.swift
//  DeliveryMobile
//
//  Created by Cuong Pham on 2/26/19.
//  Copyright © 2019 Cuong Pham. All rights reserved.
//

import UIKit

class MealListTableViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var meals = [Meal]()
    
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantName = restaurant?.name {
            
            self.navigationItem.title = restaurantName
        }
        
        loadMeals()

    }
    
    func loadMeals(){
        
        Helpers.showActivityIndicator(activityIndicator, view)
        
        if let restaurantID = restaurant?.id{
            
            APIManager.shared.getMeals(restaurantID: restaurantID,completionHandler:  { (json) in
                
                if json != nil {
                    self.meals = []
                    if let tempMeals = json["meals"].array {
                        for item in tempMeals {
                            let meal = Meal(json: item)
                            self.meals.append(meal)
                        }
                        
                        self.tableView.reloadData()
                        Helpers.hideActivityIndicator(self.activityIndicator)
                    }
                }
            })
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MealDetails"{
            
            let controller = segue.destination as! MealDetailsViewController
            controller.meal = meals[(tableView.indexPathForSelectedRow?.row)!]
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealViewCell
        
        let meal = meals[indexPath.row]
        cell.lbMealName.text = meal.name
        cell.lbShortDescription.text = meal.short_description
        
        if let price = meal.price {
            cell.lbMealPrice.text = "$\(price)"
        }
        
        if let image = meal.image {
            Helpers.loadImage(cell.imgMealImage,"\(image)")
        }
        
        return cell
    }

}
