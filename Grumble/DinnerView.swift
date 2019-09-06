//
//  DinnerView.swift
//  Grumble
//
//  Created by Luis Juarez on 9/5/19.
//  Copyright © 2019 SkyCloud. All rights reserved.
//

import Foundation
import UIKit

class DinnerViewController: UITableViewController {
    
    //generates mock data
    private var dinnerItems = DinnerItem.getMockData()
    
    @IBAction func addItemButton(_ sender: Any) {
        didTapAddItemButton()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //number of sections the UI table generates
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //creates cells based on how many items are already saved to dinnerItems array
        return dinnerItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //copies data from the tableview model to the cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "dinnerCell", for: indexPath)
        //this if ensures that indexpath does not exception when we try to set the value
        if indexPath.row < dinnerItems.count {
            let item = dinnerItems[indexPath.row]
            cell.textLabel?.text = item.dinnerTitle
            //adds accessory to the cell item
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < dinnerItems.count {
            let item = dinnerItems[indexPath.row]
            item.done = !item.done
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func didTapAddItemButton()
    {
        //create alert to allow input of new item
        let alert = UIAlertController(title: "New Dinner item", message: "Enter the title of the new Dinner item", preferredStyle: .alert)
        
        //add a text field to the alert item
        alert.addTextField(configurationHandler: nil)
        
        //add a cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text
            {
                if title == "" {
                    //checks if input has been left blank
                    
                }else{
                //calls method if OK is tapped
                self.addNewDinnerItem(title: title)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func addNewDinnerItem(title: String)
    {
        //new index is where the new item will go into the dinnerItems array
        let newIndex = dinnerItems.count
        //creates a new item and appends it to the array
        dinnerItems.append(DinnerItem(title: title))
        //update the table view
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {//allows swipe to delete item
        if indexPath.row < dinnerItems.count {
            dinnerItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup here
        self.title = "Dinner List"
    }
    
    override func viewDidAppear(_ animated: Bool) {
    //loads things once the view has appeared
}
    
}
