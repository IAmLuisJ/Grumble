//
//  HomeModel.swift
//  Grumbl
//
//  Created by Luis on 7/27/18.
//  Copyright © 2018 SkyCloud. All rights reserved.
//
// Following the model view controller model, creating a class to handle parsing the json information from the web server
// pulls JSON data from service.php file and parses it to send to view

import Foundation

//protocol will serve to transfer data from the home model to the view controller
protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class HomeModel: NSObject, URLSessionDelegate {
    //properties
    weak var delegate: HomeModelProtocol!
    var data = Data()
    let urlPath: String = "http://skycloudapps.com/GrumbleService.php"
    
 //functions
    //downloads items
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("failed to download data")
            }else {
                print("Data Downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
        
    }
    
    //parses json
    func parseJSON(_ data:Data) {
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        print(jsonResult)
        print(jsonResult.count)
        //loops through data downloaded and parsed into results and adds the items to the NSDictionary
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            let location = FoodModel()
        
        //the following insures none of the json element values are nil through optional binding
        if let id = jsonElement["id"] as? String,
        let name = jsonElement["foodName"] as? String,
        let foodImage = jsonElement["foodImage"] as? String,
        let longitude = jsonElement["delivery"] as? String,
        let latitude = jsonElement["gluttenFree"] as? String
        {
            location.id = id
            location.foodName = name
            location.foodImage = foodImage
            location.delivery = latitude
            location.gluttenFree = longitude
            print(name)
            
        }
        locations.add(location)
        }//end of for loop
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: locations)
            
        })
    }
}
