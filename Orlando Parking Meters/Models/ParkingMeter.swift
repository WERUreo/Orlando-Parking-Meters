//
//  ParkingMeter.swift
//  Orlando Parking Meters
//
//  Created by Keli'i Martin on 5/24/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class ParkingMeter
{
    var poleID: Int?
    var poleMeter: Int?
    var zone: Int?
    var area: String?
    var latitude: Double?
    var longitude: Double?

    init(json: JSON)
    {
        if let poleID = json["meter_count"].string
        {
            self.poleID = Int(poleID)
        }

        if let poleMeter = json["pole_meter"].string
        {
            self.poleMeter = Int(poleMeter)
        }

        if let zoneID = json["zone"].string
        {
            self.zone = Int(zoneID)
        }

        if let area = json["area"].string
        {
            self.area = area
        }

        if let latitude = json["coordinates"]["latitude"].string
        {
            self.latitude = Double(latitude)
        }

        if let longitude = json["coordinates"]["longitude"].string
        {
            self.longitude = Double(longitude)
        }
    }
}