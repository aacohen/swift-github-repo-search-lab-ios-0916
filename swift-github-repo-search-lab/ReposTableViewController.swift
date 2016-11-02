//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    @IBAction func searchButton(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .default)
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { (action) in
            let searchTextField = alertController.textFields[0] as UITextField
            
            let searchText = searchTextField.text
        }
        searchAction.isEnabled = true
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(searchAction)
        alertController.addAction(submitAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories{
            DispatchQueue.main.async{
                self.tableView.reloadData()
                print(self.store.repositories.count)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Did select row: \(indexPath.row)")
        
        let selectedRepo = store.repositories[indexPath.row]
        let fullName = selectedRepo.fullName
        
        print("Full name of repo is \(fullName)")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        ReposDataStore.toggleStar(for: fullName) { starred in
            if starred {
                alertController.message = "You just starred \(fullName)"
                alertController.accessibilityLabel = "You just starred \(fullName)"
                self.present(alertController, animated: true, completion: nil)
                let defaultAction = UIAlertAction(title: "Close", style: .default , handler: nil)
                alertController.addAction(defaultAction)
                
            } else {
                alertController.message = "You just unstarred \(fullName)"
                alertController.accessibilityLabel = "You just unstarred \(fullName)"
                self.present(alertController, animated: true, completion: nil)
                let defaultAction = UIAlertAction(title: "Close", style: .default , handler: nil)
                alertController.addAction(defaultAction)
            }
        }
    }

}
