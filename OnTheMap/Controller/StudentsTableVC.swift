//
//  StudentsTableVC.swift
//  OnTheMap
//
//  Created by Renad nasser on 20/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import UIKit

class StudentsTableVC: CommonViewController {
    
    //MARK: -Outlet
    @IBOutlet var tableView: UITableView!
    
    //MARK: -Proprites
    override var students: [StudentLocation]? {
        didSet {
            guard let students = students else { return }
            locations = students       }
    }
    
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: -Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

// MARK: - extension StudentsTableVC: UITableViewDelegate, UITableViewDataSource
extension StudentsTableVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "location")!
        let location = self.locations[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = location.firstName+""+location.lastName
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.locations[(indexPath as NSIndexPath).row]
        
        guard let mediaURL = URL(string: location.mediaURL) else{
            ErrorHandller.showAlert(title: "invalidURL", message: "", viewController: self)
            return
        }
        UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
        
    }
    
}//End Class

