//
//  InformationPostingVC.swift
//  OnTheMap
//
//  Created by Renad nasser on 21/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingVC: UIViewController{
    
    //MARK: -Outlet
    @IBOutlet weak var locationTextFieled: UITextField!
    @IBOutlet weak var mediaLinkTextFieled: UITextField!
    @IBOutlet weak var activityIndcator: UIActivityIndicatorView!
    
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: - Methods
    
    //MARK: - Cancel
    @IBAction func camcelCliked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)    }
    
    //MARK: - Check conditions
    @IBAction func findLocationClicked(_ sender: UIButton) {
        
        // check both fieleds not empty
        guard let location = locationTextFieled.text,
            let mediaLink = mediaLinkTextFieled.text,
            location != "", mediaLink != "" else {
                
                ErrorHandller.showAlert(title: "Missing Fields", message: "Please make sure fill both text fields", viewController: self)
                return
        }
        
        // check geocode Coordinates
        self.gecodeGnrator(locationString: location, mediaURL: mediaLink)
    }
    
    //MARK: - Gecode gnrator
    private func gecodeGnrator(locationString:String, mediaURL: String) {
        
        self.activityIndcator.startAnimating()
        
        //convert location's locationString to coordinates
        CLGeocoder().geocodeAddressString(locationString) { (placeMarks, err) in
            
            //Handel Error
            if err != nil {
                ErrorHandller.showAlert(title: "", message: "Please make sure the location is correct", viewController: self)
                self.activityIndcator.stopAnimating()
                return
            }
            
            self.activityIndcator.stopAnimating()
            
            //No location Found
            guard let firstLocation = placeMarks?.first?.location else {
                
                ErrorHandller.showAlert(title: "", message: "Couldn't found entered location", viewController: self)
                return }
            
            //StudentLocation object
            let latitude =  firstLocation.coordinate.latitude
            let longitude = firstLocation.coordinate.longitude
            
            let newLocation = PostStudentLocation(uniqueKey: APICalls.accountUniqeKey , firstName: APICalls.fristName, lastName: APICalls.lastName, mapString: locationString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
            
            //performSegue mapSegue identifier and pass newLocation
            self.performSegue(withIdentifier: "showLocation", sender: newLocation)
        }
        
        
    }
    
    //MARK:  Prepare for seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation", let ConfirmLocationVC = segue.destination as? ConfirmLocationVC {
            ConfirmLocationVC.studentLocation = (sender as! PostStudentLocation)
        }
    }
    
    
}//End Class
