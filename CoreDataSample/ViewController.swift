//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Twnibit_Raihan on 18/2/20.
//  Copyright © 2020 Twnibit_Raihan. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!

    // Step 3: Create AppDelegate singleton & instance context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Step 4: Create an array for display data
    var listArray = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    // Step 5: Create Data
    
    func saveData()
    {
        do{
            try context.save()
        }
        catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    // Step 6: Read Data
    func loadData()
    {
        let request : NSFetchRequest <List>  = List.fetchRequest()
        
        do{
            listArray = try context.fetch(request)
        }
        catch{
            print("Error loading data \(error)")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addItemsButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Create new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = List(context: self.context)
            newItem.name = textField.text
            
            self.listArray.append(newItem)
            self.saveData()
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item Here"
            textField = alertTextField
        }
        present(alert,animated: true, completion: nil)
    }
    
    
}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = listArray[indexPath.row].name
        cell.textLabel?.text = item
        return cell
    }
    // Step 7: Update data
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               var textField = UITextField()
               let alert = UIAlertController(title: "Change List item", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Update Item", style: .default) { (action) in
                self.listArray[indexPath.row].setValue(textField.text, forKey: "name")
                   self.saveData()
               }
               
               alert.addAction(action)
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "New Item Here"
                   textField = alertTextField
               }
               present(alert,animated: true, completion: nil)
        
        
    }*/
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            context.delete(listArray[indexPath.row])
            listArray.remove(at: indexPath.row)
            saveData()
        }
        
        if editingStyle == .insert{
            var textField = UITextField()
            let alert = UIAlertController(title: "Change List item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Update Item", style: .default) { (action) in
             self.listArray[indexPath.row].setValue(textField.text, forKey: "name")
                self.saveData()
            }
            
            alert.addAction(action)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New Item Here"
                textField = alertTextField
            }
            present(alert,animated: true, completion: nil)

        }
    }
    */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.context.delete(self.listArray[indexPath.row])
            self.listArray.remove(at: indexPath.row)
            self.saveData()
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, sourceView, completionHandler) in
            
            var textField = UITextField()
            let alert = UIAlertController(title: "Change List item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Update Item", style: .default) { (action) in
             self.listArray[indexPath.row].setValue(textField.text, forKey: "name")
                self.saveData()
            }
            
            alert.addAction(action)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "New Item Here"
                textField = alertTextField
            }
            self.present(alert,animated: true, completion: nil)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfig
    }
      
    
    
}

