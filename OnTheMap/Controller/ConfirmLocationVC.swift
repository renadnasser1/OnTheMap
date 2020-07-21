//
//  ConfirmLocationVC.swift
//  OnTheMap
//
//  Created by Renad nasser on 21/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import Foundation
import MapKit

class ConfirmLocationVC: UIViewController{
    //MARK: -Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Proprites
    var studentLocation :PostStudentLocation?
    
    //MARK: - Life cucle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPin()
        
    }
    //MARK: -
    private func setupPin() {
        
        guard let location = studentLocation else {
            return }
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        
        //Create MKPointAnnotation
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        
        //Add annotition
        mapView.addAnnotation(annotation)
        
        // Setting current mapView's region at pin's coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    
    
    //MARK: - Finsh
    @IBAction func finshClicked(_ sender: Any) {


        APICalls.postStudentLocation(mapString: studentLocation!.mapString, mediaURL: studentLocation!.mediaURL, lat: studentLocation!.latitude, log: studentLocation!.longitude, completion:{ (response, error) in
            
            guard let _ = response else {

                ErrorHandller.showAlert(title: "", message: "Check You'er Connection", viewController: self)
                return
            }

            if error != nil  {

                ErrorHandller.showAlert(title: "", message: "Check You'er Connection", viewController: self)
                return
            }
            
            // Dismiss View
            self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    
    
    
    //MARK: - MAP View methods
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}//End class




