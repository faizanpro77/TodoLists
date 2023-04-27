//
//  ViewController.swift
//  TodoList
//
//  Created by MD Faizan on 01/04/23.
//

//using NSCode

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
       loadItems()
        
       
        
////         Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//            print("==============>\(itemArray)")
//        }
        
        
    }
    
    //MARK - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("=======>cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        //  value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(ItemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
    
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
     
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        //it for after clicking on cell checkbox appear on perticular cell
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //it for after clicking on cell background highlight and dissmiss diselect automatic
       
    }
    
    
    //Mark - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user click the Add Item button on our UIAlert
            
            
            let newItem = Item()
            newItem.title = textFeild.text!
            self.itemArray.append(newItem)
            self.saveItems()
           
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            //completion block
            alertTextField.placeholder = "Create new item"
            textFeild = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

