//
//  ViewController.swift
//  hello-maps
//
//  Created by Mohammad Azam on 8/5/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView :MKMapView!
    private let locationManager = CLLocationManager()
    
    let annotationFactory = AnnotaionFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    }
    
    @IBAction func showAddAddressView() {
        
        let alertVC = UIAlertController(title: "Enter Point of Interest", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField { textField in
            
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            
            if let textField = alertVC.textFields?.first,
                let search = textField.text {
                
                self.findNearbyPOI(by :search)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func findNearbyPOI(by searchTerm :String) {
        
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        let request = MKLocalSearch.Request() 
        request.naturalLanguageQuery = searchTerm
        request.region = self.mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            
            guard let response = response, error == nil else {
                return
            }
            
            for mapItem in response.mapItems {
                
                print(mapItem.name!)
                self.addPlacemarkToMap(placemark :mapItem.placemark)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var businessAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BusinessAnnotationView")
        
        if businessAnnotationView == nil {
            
            let businessVM = annotation as! BusinessViewModel
            
            businessAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "BusinessAnnotationView")
            businessAnnotationView?.canShowCallout = true
            businessAnnotationView?.image = businessVM.image
            
            
        } else {
            businessAnnotationView?.annotation = annotation
        }
        
        return businessAnnotationView
        
    }
    
    private func getRandomRating() -> Double {
        return Double.random(in: 1...5)
    }
    
    // this function is used to add the placemark on the map
    private func addPlacemarkToMap(placemark :CLPlacemark) {
       
        guard let location = placemark.location,
              let name = placemark.name
        else {
            return
        }
        
        let business = Business(name: name, location: location, rating: getRandomRating())
        let businessVM = annotationFactory.createBusinessFactory(business: business)
        
        self.mapView.addAnnotation(businessVM)
       
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        
        mapView.setRegion(region, animated: true)
    }
    

}

