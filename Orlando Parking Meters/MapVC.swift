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

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    ////////////////////////////////////////////////////////////
    // MARK: - Outlets
    ////////////////////////////////////////////////////////////

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toolbar: UIToolbar!

    ////////////////////////////////////////////////////////////
    // MARK: - Properties
    ////////////////////////////////////////////////////////////

    let centerPoint = CLLocationCoordinate2DMake(28.540655, -81.381483)
    var meters = [ParkingMeter]()
    let clusteringManager = FBClusteringManager()
    lazy var locationManager = CLLocationManager()

    ////////////////////////////////////////////////////////////
    // MARK: - View Conroller Lifecycle
    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }

        //mapView.showsUserLocation = true
        mapView.userTrackingMode = .None

        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        var barItems = [UIBarButtonItem]()
        barItems.append(userTrackingButton)
        self.toolbar.setItems(barItems, animated: true)

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

                let region = MKCoordinateRegionMakeWithDistance(self.centerPoint, 2000, 2000)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }

    ////////////////////////////////////////////////////////////
    // MARK: - CLLocationManagerDelegate
    ////////////////////////////////////////////////////////////

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
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
        else if annotation is MeterAnnotation
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

        return nil
    }
}




