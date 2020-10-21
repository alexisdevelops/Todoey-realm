//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ivan Garza on 9/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar
            else {fatalError("Navigation bar in toDoListController does not exist")}

        navBar.backgroundColor = .systemBlue
    }
    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add Category", style: .default) { (action) in
            
            let category = Category()
            category.name = textField.text!
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - tableView dataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currCategory = categories?[indexPath.row] {
            if let currentCategoryColor = currCategory.backgroundColor {
                cell.backgroundColor = UIColor(hexString: currentCategoryColor)
                cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: currentCategoryColor)!, returnFlat: true)
            } else {
                print("Didin hav background color")
                updateCategoryColor(category: currCategory)
            }
            cell.textLabel?.text = currCategory.name
 
        }

        return cell
    }
    
    //MARK: - data manipulation Methods
    func updateCategoryColor(category: Category) {
        do {
            try realm.write{
                category.backgroundColor = ChameleonFramework.RandomFlatColor().hexValue()
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let selectedCategory =  self.categories?[indexPath[0]] {
            do{
                try self.realm.write {
                    self.realm.delete(selectedCategory)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }

    
    //MARK: - tableView delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath  = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
