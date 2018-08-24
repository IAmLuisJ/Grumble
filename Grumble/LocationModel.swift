//
//  LocationModel.swift
//  Grumble
//
//  Created by Luis on 7/27/18.
//  Copyright © 2018 SkyCloud. All rights reserved.
// Object model that holds information parsed from MySQL database
//container to store incoming data

import Foundation

class LocationModel: NSObject {
    //properties
    
    var foodName: String?
    var foodImage: String?
    var latitude: String?
    var longitude: String?
    
    //empty constructor
    override init()
    {
    
    }
    
    //constructer with properties of object (foodname, foodimage, longitude, latidude)
    
    init(name: String, image: String, latitude: String, longitude: String)
    {
        self.foodName = name
        self.foodImage = image
        self.latitude =  latitude
        self.longitude = longitude
    
    }
    //prints objects current state
    
    override var description: String {
        return "Name: \(foodName!), image: \(foodImage!), latitude: \(latitude!), longitude: \(longitude!)"
    }
    
}
