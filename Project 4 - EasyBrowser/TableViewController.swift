//
//  TableViewController.swift
//  Project 4 - EasyBrowser
//
//  Created by Zeeshan Waheed on 01/02/2024.
//

import UIKit

class TableViewController: UITableViewController {
//  array containing all websites for tableview
    var websites = ["apple.com", "hackingwithswift.com", "google.com", "fast.com", "microsoft.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
        

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Websites", for: indexPath)
//      to display website name with numbering
        cell.textLabel?.text = "\(indexPath.row+1).  " + websites[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      sending the data to tableviewcontroller file
        if let vc = storyboard?.instantiateViewController(withIdentifier:"Webpage") as? ViewController {
            vc.websites = websites
            vc.SelectedSites = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}
