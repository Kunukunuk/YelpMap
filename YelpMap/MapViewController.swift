//
//  MapViewController.swift
//  YelpMap
//
//  Created by Kun Huang on 10/15/18.
//  Copyright © 2018 Kun Huang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class customAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(pinTitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.coordinate = location
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var updateCenter = false
    var restaurants: [Restaurant]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.mapView.showsUserLocation = true
        
    }
    
    func createAnnotationOnMap() {
        if let restaurants = restaurants {
            for restaurant in restaurants {
                addAnnotationAtAddress(address: restaurant.address!, title: restaurant.name!)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("Finsihed")
        updateCenter = true
        let location = locationManager.location?.coordinate
        APIManager().getRestaurants(latitude: (location?.latitude)!, longitude: (location?.longitude)!) { (rest: [Restaurant]?, error: Error?) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("successful")
                self.restaurants = rest
                self.createAnnotationOnMap()
            }
        }
    }
    
    func removeAnnotation() {
        let annotationsToRemove = mapView.annotations
        mapView.removeAnnotations( annotationsToRemove )
    }
    
    func addAnnotationAtAddress(address: String, title: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    let custom = customAnnotation(pinTitle: title, location: coordinate.coordinate)
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = title
                    self.mapView.addAnnotation(custom)
                }
            }
        }
    }
    
    /*func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        <#code#>
    }*/
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        removeAnnotation()
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if updateCenter {
            print("ending here")
            restaurants?.removeAll()
            let location = self.mapView.centerCoordinate
            APIManager().getRestaurants(latitude: location.latitude, longitude: location.longitude) { (rest: [Restaurant]?, error: Error?) in
                if let error = error {
                    print("error*** :\(error.localizedDescription)")
                } else {
                    print("successfully")
                    self.restaurants = rest
                    self.createAnnotationOnMap()
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customannotation"
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = UIImage(named: "Food")
        
        return annotationView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
