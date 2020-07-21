//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Renad nasser on 19/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import Foundation
//MARK: - StudentLocationResponse
struct StudentLocationResponse: Codable {
    let results: [StudentLocation]
}

//MARK: - StudentLocation
struct StudentLocation: Codable {
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
}

struct PostStudentLocation:Codable {
    let uniqueKey, firstName, lastName, mapString: String
    let mediaURL: String
    let latitude, longitude: Double
}

struct PostStudentLocationResponse: Codable{
    let createdAt, objectID: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
    
}

