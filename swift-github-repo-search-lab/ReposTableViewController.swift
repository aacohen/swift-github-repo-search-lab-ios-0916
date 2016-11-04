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
        print("search button getting called")
        let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            print("text entered")
        })
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            print("sumbit action getting called")
            let searchText = alertController.textFields?[0] as UITextField!
            let text = searchText?.text
            guard let textForUrl = text else {return}
//            self.submit(searchText?.text!)

            self.store.getSearchRepositories(with: textForUrl, completion: {
                print("storing search repos")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
  
        
    }
        self.present(alertController, animated: true, completion: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
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
        
        store.toggleStar(for: fullName) { starred in
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
