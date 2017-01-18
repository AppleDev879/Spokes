//
//  Bike.swift
//  Spokes
//
//  Created by Andrew Barrett on 1/13/17.
//  Copyright © 2017 Andrew Barrett. All rights reserved.
//

import Foundation
import MapKit

class Bike {
    
    var size:String
    var locationString:String
    var available:Bool
    var user:String
    var cost:Double
    
    var location: CLLocationCoordinate2D {
        switch locationString {
        case "Noah":
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        case "North":
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        default:
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
    
    init(size: String, location: String, available: Bool, cost: Double, user: String) {
        self.available = available
        self.locationString = location
        self.size = size
        self.cost = cost
        self.user = user
    }
    
}

