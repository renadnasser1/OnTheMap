//
//  StudentsMapVC.swift
//  OnTheMap
//
//  Created by Renad nasser on 19/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import UIKit
import MapKit

//MARK: StudentsMapVC: ParentVC, MKMapViewDelegate
class StudentsMapVC: CommonViewController, MKMapViewDelegate {
    
    //MARK: -Outlet
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: -Proprites
    
    override var  students : [StudentLocation]?{
        didSet{
            pin()
        }
    }
    
    
    //MARK: - life cycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        
    }
    //MARK: - Pins info
    func pin(){
        
        // Array of notitions
        var annotations = [MKPointAnnotation]()
        for location in students! {
            
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude )
            let long = CLLocationDegrees(location.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(String(describing: first)) \(String(describing: last))"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotations(annotations)
    }
    
    //MARK: - Methods mapView
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    //Opens the  browser to the URL specified in the annotationViews subtitle
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }else{
                //Handle error
                ErrorHandller.showAlert(title: "", message: "URL Cannot opened", viewController: self)
            }
        }
    }
    
}//End Class
