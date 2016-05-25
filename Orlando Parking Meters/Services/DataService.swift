//
//  DataService.swift
//  Orlando Walking Tours
//
//  Created by Keli'i Martin on 5/9/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DataService
{
    static let sharedInstance = DataService()

    func getParkingMeters(completion: (meters: [ParkingMeter]) -> Void)
    {
        let metersUrlString = "https://brigades.opendatanetwork.com/resource/6q72-v2e8.json"
        var meters = [ParkingMeter]()
        
        Alamofire.request(.GET, metersUrlString).validate().responseJSON
        { response in
            switch response.result
            {
            case .Success:
                if let value = response.result.value
                {
                    let json = JSON(value)
                    for (_, subJson) in json
                    {
                        let meter = ParkingMeter(json: subJson)
                        meters.append(meter)
                    }

                    completion(meters: meters)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}