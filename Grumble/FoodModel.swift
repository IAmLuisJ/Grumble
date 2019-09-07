//
//  LocationModel.swift
//  Grumble
//
//  Created by Luis on 7/27/18.
//  Copyright © 2018 SkyCloud. All rights reserved.
// Object model that holds information parsed from MySQL database
//container to store incoming data

import Foundation

class FoodModel: NSObject {
    //properties
    
    var id: String?
    var foodName: String?
    var foodImage: String?
    var delivery: String?
    var gluttenFree: String?
    
    //empty constructor
    override init()
    {
    
    }
    
    //constructer with properties of object (foodname, foodimage, longitude, latidude)
    
    init(id: String, name: String, image: String, delivery: String, gluttenFree: String)
    {
        self.id = id
        self.foodName = name
        self.foodImage = image
        self.delivery =  delivery
        self.gluttenFree = gluttenFree
    
    }
    //prints objects current state
    
    override var description: String {
        return "ID: \(id!) Name: \(foodName!), image: \(foodImage!), Delivery: \(delivery!), GluttenFree: \(gluttenFree!)"
    }
    
}
