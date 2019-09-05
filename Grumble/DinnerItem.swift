//
//  DinnerItem.swift
//  Grumble
//
//  Created by Luis Juarez on 9/5/19.
//  Copyright © 2019 SkyCloud. All rights reserved.
//

import Foundation

class DinnerItem {
    var dinnerTitle: String
    var dinnerDay: String
    var done: Bool
    
    public init(title: String)
    {
        self.dinnerTitle = "dinner"
        self.dinnerDay = "Sunday"
        self.done = false
    }
    
    public func setDinnerTitle(incomingDinnerTitle: String) {
        self.dinnerTitle = incomingDinnerTitle
    }
    
    public func setDinnerDay(incomingDinnerDay: String) {
        self.dinnerDay = incomingDinnerDay
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
