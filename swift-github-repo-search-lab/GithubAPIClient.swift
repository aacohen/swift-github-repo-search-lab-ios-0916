//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        
        Alamofire.request(urlString).responseJSON { (response) in
            if let json = response.result.value as? [Any] {
                
                print("JSON:\(json)")
                completion(json)
                
                }
                
           
                }

            
            
        }
    
//        guard let unwrappedURL = url else { fatalError("Invalid URL") }
//        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
//            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
//            
//            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
//                print(1)
//                if let responseArray = responseArray {
//                    print(2)
//                    completion(responseArray)
//                }
//            }
//        })
//        task.resume()
    
    
    
    class func checkIfRepositoryIsStarred(_ name: String, completion: @escaping (Bool) -> Void) {
        
        let baseURL: String = "https://api.github.com"
        
        let searchStarredURL: String = "/user/starred/\(name)"
        
        let tokenURL: String = "?access_token=\(Secrets.token)"
        
        let urlString = baseURL + searchStarredURL + tokenURL
        
        guard let url = URL(string: urlString) else { completion(false); return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //you can also use URLSessionConfiguration.shared
        
        let task = session.dataTask(with: request) { data, response, error in
         
            
            //guard let response = response else { fatalError("error") }
            let httpresponse = response as! HTTPURLResponse
            
            var starredStatus = false
            
                if httpresponse.statusCode == 204 {
                    starredStatus = true
                }
                else if httpresponse.statusCode == 404 {
                    starredStatus = false
                }
                //print(response)
            
            
            completion(starredStatus)
            
            
            }
            task.resume()
        
    }
    
    
        
    class func starRepo(for name:String, completion:@escaping (Bool)->()){
        
        
        let baseURL = "https://api.github.com"
        let starredURL = "/user/starred/\(name)"
        let tokenURL: String = "?access_token=\(Secrets.token)"
        let URLString = baseURL + starredURL + tokenURL
        let url = URL(string: URLString)
        
        guard let unwrappedURL = url else { return }
        
        var request = URLRequest(url: unwrappedURL)
        
        //request.addValue("0", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "PUT"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            
            var starred = false
            if httpResponse.statusCode == 204 {
                starred = true
            } else if httpResponse.statusCode == 404 {
                starred = false
            }

            
            completion(starred)
            
        }
        
        task.resume()
        
    }
    class func unstarRepo(for name:String, completion:@escaping (Bool)->()){
        let baseURL = "https://api.github.com"
        let starredURL = "/user/starred/\(name)"
        let tokenURL: String = "?access_token=\(Secrets.token)"
        let URLString = baseURL + starredURL + tokenURL
        let url = URL(string: URLString)
        
        guard let unwrappedURL = url else { return }
        
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "DELETE"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            
            var unstarred = false
            if httpResponse.statusCode == 204 {
                unstarred = true
            } else if httpResponse.statusCode == 404 {
                unstarred = false
            }
            
        completion(unstarred)
            
        }
        
        
        
        task.resume()
    }
    
    
    //currently working on this function.
    class func repoSearch (name: String, completion: @escaping ([[String: AnyObject]]) -> ()) {
        let url = "\(Secrets.githubAPIURL)/search/repositories"
        let q = "?q="
        let textToSearch = "\(name)"
        
        let searchString = url + q + textToSearch

        print("search URL: \(searchString)")
        
        
        
        
        Alamofire.request(searchString).responseJSON { (response) in
            print(response.result.value)
            if let json = response.result.value as? [String: Any] {
                let dictionary = json["items"] as! [[String: AnyObject]]
                
                print("JSON:\(json)")
                completion(dictionary)

                
            }
        }
        
        
        
    }
}

