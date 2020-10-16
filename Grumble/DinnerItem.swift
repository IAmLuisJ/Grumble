//
//  DinnerItem.swift
//  Grumble
//
//  Created by Luis Juarez on 9/5/19.
//  Copyright © 2019 SkyCloud. All rights reserved.
//

import Foundation

class DinnerItem: NSObject, NSCoding {
    var dinnerTitle: String
    var dinnerDay: String
    var done: Bool
    
    public init(title: String)
    {
        self.dinnerTitle = title
        self.dinnerDay = "Sunday"
        self.done = false
    }
    
    public func setDinnerTitle(incomingDinnerTitle: String) {
        self.dinnerTitle = incomingDinnerTitle
    }
    
    public func setDinnerDay(incomingDinnerDay: String) {
        self.dinnerDay = incomingDinnerDay
    }
    
    required init?(coder aDecoder: NSCoder) {
        // unserialize the title
        if let title = aDecoder.decodeObject(forKey: "title") as? String
        {
            self.dinnerTitle = title
        } else
        {
            //if there were no objects with key title
            return nil
        }
        
        if let day = aDecoder.decodeObject(forKey: "dinnerDay") as? String
        {
            self.dinnerDay = day
        }else {
            return nil
        }
        
        if aDecoder.containsValue(forKey: "done")
        {
            self.done = aDecoder.decodeBool(forKey: "done")
        }else {
            //if there were no objects encoded with that key
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.dinnerTitle, forKey: "title")
        aCoder.encode(self.dinnerDay, forKey: "dinnerDay")
        aCoder.encode(self.done, forKey: "done")
    }
    
}

extension DinnerItem
{
    public class func getMockData() -> [DinnerItem]
    {
        return [
            DinnerItem(title: "Spaghetti"),
            DinnerItem(title: "Hibachi"),
            DinnerItem(title: "Enchiladas Verdes"),
            DinnerItem(title: "Chicken Sandwhiches"),
            DinnerItem(title: "Mango Chicken and rice")]
    }
}

extension Collection where Iterator.Element == DinnerItem {
    //uses file manager to create path to where the serialized object file will be stored
    private static func persistencePath() -> URL?
    {
        let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url?.appendingPathComponent("dinnerItems.bin")
    }
    
    //write the dinnerItem array to local file
    func writeToPersistence() throws
    {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
            try data.write(to: url)
            print("Local Items saved")
        } else
        {
            throw NSError(domain: "errorCode", code: 10, userInfo: nil)
        }
    }
    
    //reads item from local file
    static func readFromPersistence() throws -> [DinnerItem]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [DinnerItem]
            {
                print("Items loaded: \(array)")
                return array
            }
            else {
                throw NSError(domain: "errorCode", code: 11, userInfo: nil)
            }
        }
        else {
            throw NSError(domain: "errorCode", code: 12, userInfo: nil)
        }
    }
    
    
}
