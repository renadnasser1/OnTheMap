//
//  CommonViewController.swift
//  OnTheMap
//
//  Created by Renad nasser on 19/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import Foundation
import UIKit

class CommonViewController: UIViewController {
    
    //    MARK: - Proprites
    var students : [StudentLocation]?
    
    //    MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        SetUI()
        loadLocations()
        APICalls.getFristandLastName { (success, error) in
            if !success {
                ErrorHandller.showAlert(title: "", message: "Check connection and Try login again", viewController: self)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    //MARK: - SetUI Proprites
    func SetUI(){
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutClicked(_:)))
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshClicked(_:)))
        
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocationClicked(_:)))
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [addLocationButton, refreshButton]
        
        
    }
    
    //MARK: - Load Students location
    func loadLocations(){
        
        APICalls.getSudentsLocation(){ (studentsLocation, error) in
            if error != nil {
                ErrorHandller.showAlert(title: "", message: "locations Souldn't load, Check your connection", viewController: self)
            }
            self.students = studentsLocation
            
        }
    }
    
    
    
    //MARK: -Refresh
    @objc private func refreshClicked(_ sender: Any) {
        loadLocations()
    }
    
    //MARK: - add Location
    @objc func addLocationClicked(_ sender: Any) {
        
        let  InfoPostingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InformationPostingVC") as! UINavigationController
        
        present(InfoPostingVC, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Logout
    @objc func logoutClicked(_ sender: Any) {
        APICalls.logout { (success, error) in
            if success{
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }else{
                DispatchQueue.main.async {
                    ErrorHandller.showAlert(title: "", message: "Check connection and Try logout again", viewController: self)
                }
                
            }
        }
        
    }
    
}// end calss
