//
//  DownloadData.swift
//  Stockopedia
//
//  Created by Nathan Turcich on 3/29/19.
//  Copyright © 2019 Joey Chung. All rights reserved.
//

import Foundation

var urlPath:String = "http://sp19-cs411-49.cs.illinois.edu/queries.php"

class DownloadData {
    
    static func downloadUniqueStockNames(completion:@escaping ([Stock]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=downloadUniqueStockNames")!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var stocksArray = [Stock]()
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    stocksArray.append(Stock.init(abbr: jsonElement["name"]! as! String, fullName: jsonElement["fullname"]! as! String))
                }
                completion(stocksArray)
            }
        }
        task.resume()
    }
    
    static func downloadPossibleMonths(abbr: String, completion:@escaping ([String]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=downloadPossibleMonths&abbr=" + abbr)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var months = [String]()
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    months.append(jsonElement["date"]! as! String)
                }
                completion(months)
            }
        }
        task.resume()
    }
    
    static func downloadUniqueStockDataForMonth(abbr: String, month: String, completion:@escaping ([(date: String, close: String)]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=downloadUniqueStockDataForMonth&abbr=" + abbr + "&month=" + month)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var data = [(date: String, close: String)]()
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    data.append((jsonElement["date"]! as! String, jsonElement["close"]! as! String))
                }
                completion(data)
            }
        }
        task.resume()
    }
    
    static func downloadUniqueStockDataForYear(abbr: String, year: String, completion:@escaping ([(date: String, close: String)]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=downloadUniqueStockDataForYear&abbr=" + abbr + "&year=" + year)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var data = [(date: String, close: String)]()
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    data.append((jsonElement["date"]! as! String, jsonElement["close"]! as! String))
                }
                completion(data)
            }
        }
        task.resume()
    }
    
    //Favorites Methods
    static func downloadUserFavoritedList(key: String, completion:@escaping ([(abbr: String, fullName: String)]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=downloadUserFavoritedList&key=" + key)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var favorites:[(abbr: String, fullName: String)] = []
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    favorites.append((jsonElement["abbr"]! as! String, jsonElement["fullname"]! as! String))
                }
                completion(favorites)
            }
        }
        task.resume()
    }
    
    static func insertNameFavoritedList(key: String, abbr: String, fullName: String) {
        let  url: URL = URL(string: urlPath + "?query=insertNameFavoritedList&key=" + key + "&abbr=" + abbr + "&fullname=" + fullName)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    //Recommendations Functions
    static func getTopicData(completion:@escaping ([(abbr: String, fullName:String, topic: String)]?) -> Void) {
        let url: URL = URL(string: urlPath + "?query=getTopicData")!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var jsonElement = NSDictionary()
                var topics:[(abbr: String, fullName: String, topic: String)] = []
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    topics.append((jsonElement["abbr"]! as! String, jsonElement["fullname"]! as! String, jsonElement["topic"]! as! String))
                }
                completion(topics)
            }
        }
        task.resume()
    }
    
    static func getUserRecommendations(key: String, completion:@escaping (String) -> Void) {
        let url: URL = URL(string: urlPath + "?query=getUserRecommendations&key=" + key)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion("")
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                let jsonElement = jsonResult[0] as! NSDictionary
                completion(jsonElement["Recomendation"]! as! String)
            }
        }
        task.resume()
    }
    
    static func initilizeUsersRecomendations(key: String) {
        let  url: URL = URL(string: urlPath + "?query=initilizeUsersRecomendations&key=" + key)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    static func updateUserRecomendations(key: String, recomendation: String) {
        let  url: URL = URL(string: urlPath + "?query=updateUserRecomendations&key=" + key + "&recomendation=" + recomendation.replacingOccurrences(of: " ", with: "+"))!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    //User Functions
    static func createUser(key: String, username: String, password: String) {
        let  url: URL = URL(string: urlPath + "?query=createUser&key=" + key + "&username=" + username + "&password=" + password)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    static func getUser(username: String, password: String, completion:@escaping (User?) -> Void) {
        let url: URL = URL(string: urlPath + "/?query=getUser&username=" + username + "&password=" + password)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion(nil)
            }else {
                var jsonResult = NSArray()
                do {jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                } catch let error as NSError { print(error) }
                
                var user: User!
                var jsonElement = NSDictionary()
                for i in 0 ..< jsonResult.count {
                    jsonElement = jsonResult[i] as! NSDictionary
                    user = User(ID: jsonElement["ID"] as! String, username: jsonElement["Username"] as! String)
                }
                completion(user)
            }
        }
        task.resume()
    }
    
    static func deleteNameFavoritedList(key: String, name: String) {
        let  url: URL = URL(string: urlPath + "?query=deleteNameFavoritedList&key=" + key + "&name=" + name)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    static func updateUserPassword(key: String, newPassword: String) {
        let  url: URL = URL(string: urlPath + "?query=updateUserPassword&key=" + key + "&newPassword=" + newPassword)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
    
    static func updateUsername(key: String, newUsername: String){
        let  url: URL = URL(string: urlPath + "?query=updateUsername&key=" + key + "&newUsername=" + newUsername)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
}
