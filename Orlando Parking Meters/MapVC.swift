//
//  Map VC
//  Orlando Parking Meters
//
//  Created by Keli'i Martin on 5/24/16.
//  Copyright © 2016 Code for Orlando. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapVC: UIViewController, MKMapViewDelegate
{
    ////////////////////////////////////////////////////////////
    // MARK: - Outlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var mapView: MKMapView!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    let centerPoint = CLLocationCoordinate2DMake(28.540655, -81.381483)
    var meters = [ParkingMeter]()

    ////////////////////////////////////////////////////////////
    // MARK: - View Conroller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self

        let region = MKCoordinateRegionMakeWithDistance(centerPoint, 2000, 2000)
        mapView.setRegion(region, animated: true)

        DataService.sharedInstance.getParkingMeters
        { meters in
            var annotations = [MeterAnnotation]()
            for meter in meters
            {
                let annotation = MeterAnnotation(meter: meter)
                annotations.append(annotation)
            }

            dispatch_async(dispatch_get_main_queue())
            {
                self.mapView.addAnnotations(annotations)
            }
        }
    }
}

