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
import FBAnnotationClusteringSwift

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
    let clusteringManager = FBClusteringManager()

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
                self.clusteringManager.addAnnotations(annotations)
            }
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - MKMapViewDelegate
    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        NSOperationQueue().addOperationWithBlock
        {
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            let mapRectWidth = self.mapView.visibleMapRect.size.width
            let scale = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale: scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView: self.mapView)
        }
    }

    ////////////////////////////////////////////////////////////

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var reuseID = ""

        if annotation is FBAnnotationCluster
        {
            reuseID = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseID, options: nil)
            return clusterView
        }
        else
        {
            reuseID = "Pin"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)

            if annotationView != nil
            {
                annotationView?.annotation = annotation
            }
            else
            {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
                annotationView?.image = UIImage(named: "parking-meter")
                annotationView?.canShowCallout = true
            }

            return annotationView
        }
    }
}




