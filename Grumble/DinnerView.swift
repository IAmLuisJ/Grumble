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
    
    public func addNewDinnerItem(title: String)
    {
        //new index is where the new item will go into the dinnerItems array
        let newIndex = dinnerItems.count
        //creates a new item and appends it to the array
        dinnerItems.append(DinnerItem(title: title))
        //update the table view
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//       return false
//    }
//
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {//allows swipe to delete item
        if indexPath.row < dinnerItems.count {
            dinnerItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //update the data source for reordered list
        let movedObject = self.dinnerItems[sourceIndexPath.row]
        dinnerItems.remove(at: sourceIndexPath.row)
        dinnerItems.insert(movedObject, at: destinationIndexPath.row)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup here
        self.title = "Dinner List"
        self.tableView.isEditing = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        do {
            //try to load from bin file
            self.dinnerItems = try [DinnerItem].readFromPersistence()
        } catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                print("No persistence file found")
            } else {
                let alert = UIAlertController(title: "Error", message: "Unable to load Food items", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Error loading from file \(error)")
            }
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    //loads things once the view has appeared
}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            do {
                try dinnerItems.writeToPersistence()
            } catch let error
            {
                print("Error saving to file: \(error)")
            }
        }
    }
    
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification)
    {
        //this is called when the observer sees that the app entered the background
        do {
            try dinnerItems.writeToPersistence()
        } catch let error
        {
            print("Error saving to file: \(error)")
        }
    }
    
}
