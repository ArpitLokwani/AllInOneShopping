//
//  APIManager.swift
//  VirusTracker
//
//  Created by Arpit Lokwani on 21/03/20.
//  Copyright © 2020 SendBird. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIManager: NSObject {
   let baseURLs = "http://api.newshealthtracker.com:8000"



    let baseURL = "http://smartlycompare.com/allinone/index.php/"
    static let sharedInstance = APIManager()
   static let getAllDiseaseEndPoints = "/disease"
    static let getAllRecords = "/records"
    static let getAllFeeds = "/feeds"
    static let getAllSettingsEndPoints = "/api/v1//ios"
    static let getAllChatsEndPoints = "/chats"
    static let getChatUserInfo = "/chats"
    
    //categories
    static let getCategories = "api/category/v2_categoryAllDetail?OsType=1&AppId=1"
    
    
        func getAllCategories(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getCategories
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }catch{
                    
                }
                
            }
        })
        task.resume()
    }
    
    
    
    
    
        func getAllSettingURL(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURLs + APIManager.getAllSettingsEndPoints
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }catch{
                    
                }
                
            }
        })
        task.resume()
    }
    
    
    

        func getUserProfile(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getChatUserInfo
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }catch{
                    
                }
                
            }
        })
        task.resume()
    }
    
    
    func getAllDiseases(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
    let url : String = baseURL + APIManager.getAllDiseaseEndPoints
    let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
    request.httpMethod = "GET"
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        if(error != nil){
            onFailure(error!)
        } else{
            do{
                let result = try JSON(data: data!)
                onSuccess(result)
            }catch{
                
            }
            
        }
    })
    task.resume()
}
     func getChatID(id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURLs + APIManager.getAllChatsEndPoints
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        //let postString = "disease_id=\(id)&page=0&country_id=0&state_id=&city_id=";
        //request.httpBody = postString.data(using: String.Encoding.utf8);

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }catch{
                    
                }
                
            }
        })
        task.resume()
    }
    

     func getAllRecords(diseaseID: Int,state_id: Int,page: Int,city_id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.getAllRecords
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        
//        let params = [
//        "disease_id": 7,
//        "page": 0,
//        "country_id": 0  ,
//        "state_id": 0,
//        "city_id": 0 ,
//
//        ]
        let postString = "disease_id=\(diseaseID)&page=0&country_id=0&state_id=&city_id=";
        request.httpBody = postString.data(using: String.Encoding.utf8);
       // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                do{
                    let result = try JSON(data: data!)
                    onSuccess(result)
                }catch{
                    
                }
                
            }
        })
        task.resume()
    }


         func getAllFeeds(diseaseID: Int,state_id: Int,page: Int,city_id: Int, onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
            let url : String = baseURL + APIManager.getAllFeeds
            let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
            request.httpMethod = "POST"
            
    //        let params = [
    //        "disease_id": 7,
    //        "page": 0,
    //        "country_id": 0  ,
    //        "state_id": 0,
    //        "city_id": 0 ,
    //
    //        ]
            let postString = "disease_id=\(diseaseID)&page=0&country_id=0&state_id=&city_id=";
            request.httpBody = postString.data(using: String.Encoding.utf8);
           // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if(error != nil){
                    onFailure(error!)
                } else{
                    do{
                        let result = try JSON(data: data!)
                        onSuccess(result)
                    }catch{
                        
                    }
                    
                }
            })
            task.resume()
        }
    
    
    
    
}

