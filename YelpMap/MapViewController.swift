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
    var subtitle: String?
    var extraInfo: String?
    var restaurantImage: UIImage?
    
    init(location: CLLocationCoordinate2D) {
        self.coordinate = location
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var updateCenter = false
    var showAnnotation = true
    var previousRestaurant: String = ""
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
        removeAnnotation()
        if let restaurants = restaurants {
            for restaurant in restaurants {
                var image: UIImage?
                if restaurant.imageURL == nil {
                    image = UIImage(named: "Food")
                } else {
                    if let data = try? Data(contentsOf: restaurant.imageURL!) {
                        image = UIImage(data: data)
                    }
                }
                addAnnotationAtAddress(address: restaurant.address!, title: restaurant.name!, image: image!)
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
        restaurants?.removeAll()
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
    
    func addAnnotationAtAddress(address: String, title: String, image: UIImage) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let custom = customAnnotation(location: coordinate.coordinate)
                    custom.restaurantImage = image
                    custom.title = title
                    custom.subtitle = address
                    custom.extraInfo = "********"
                    self.mapView.addAnnotation(custom)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "GoToDetails", sender: self)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if showAnnotation {
            showAnnotation = false
        } else {
            for selectedAnnotation in mapView.selectedAnnotations {
                mapView.deselectAnnotation(selectedAnnotation, animated: true)
            }
            showAnnotation = true
        }
    }
    
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
        let identifier = "customAnnotation"
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let custom = annotation as! customAnnotation
        // custom image annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let pinImage = custom.restaurantImage
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView?.image = resizedImage
            
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            
        }
    }

}
