//
//  TableViewController.swift
//  BucketList
//
//  Created by amnah alhwaiml on 13/05/1443 AH.
//

import UIKit
import CoreData

class TableViewController: UITableViewController , AddItemViewControllerDelegate {
  
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
   
var items = [BucketListItems]()
    

    func fetchAllItems(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItems")
        
        do{
            let result = try managedObjectContext.fetch(request)
            items = result as! [BucketListItems]
        }catch{
            print("Something went wrong")
        }
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .detailDisclosureButton
        cell.textLabel?.text = items[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "DetalisID", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue"{
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddViewController
            
            addItemTableViewController.delegate = self
        }
        else if segue.identifier == "DetalisID"{
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddViewController
            addItemTableViewController.delegate = self
            
            let indexPath = sender as! NSIndexPath
            
            addItemTableViewController.item = items[indexPath.row].name
            addItemTableViewController.indexPath = indexPath
        }
    }
    
    func cancelButtonPressed(by controller: AddViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemSaved(by controller: AddViewController, with text: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath{
            
            let item = items[ip.row]
            item.name = text
            items.append(item)

            tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
        else{
            let thing = NSEntityDescription.insertNewObject(forEntityName: "BucketListItems", into: managedObjectContext) as! BucketListItems
            thing.name = text
            items.append(thing)
            tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.classForKeyedArchiver(), forCellReuseIdentifier: "Cell")
        

        print("hi")
        tableView.reloadData()

   

}
   
}
