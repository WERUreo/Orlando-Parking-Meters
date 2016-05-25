//
//  MeterAnnotation.swift
//  Orlando Parking Meters
//
//  Created by Keli'i Martin on 5/25/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import UIKit
import MapKit

class MeterAnnotation: NSObject, MKAnnotation
{
    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    let coordinate: CLLocationCoordinate2D
    var title: String? = nil
    var subtitle: String? = nil
    let defaultLocation = CLLocationCoordinate2DMake(28.540655, -81.381483)

    ////////////////////////////////////////////////////////////
    // MARK: - MKAnnotation
    ////////////////////////////////////////////////////////////

    init(meter: ParkingMeter)
    {
        if let latitude = meter.latitude,
           let longitude = meter.longitude
        {
            self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        }
        else
        {
            self.coordinate = defaultLocation
        }

        if let title = meter.poleMeter,
           let subtitle = meter.area
        {
            self.title = String(title)
            self.subtitle = subtitle
        }
    }
}
