//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositories(with completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()

        }
    }

    
    class func toggleStar(for name:String, completion:@escaping (Bool)->()){
        GithubAPIClient.checkIfRepositoryIsStarred(name) { (isStarred) in
            if isStarred == true{
                GithubAPIClient.unstarRepo(for: name, completion: { (success) in
                    completion(false)
                })
                
            }else{
                GithubAPIClient.starRepo(for: name, completion: { (success) in
                    completion(true)

                })
                
            }
            
            
        }
        
    }


}
