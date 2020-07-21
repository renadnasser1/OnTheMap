//
//  APICalls.swift
//  OnTheMap
//
//  Created by Renad nasser on 17/07/2020.
//  Copyright © 2020 Renad nasser. All rights reserved.
//

import Foundation

class APICalls{
    static var accountUniqeKey : String = ""
    static var fristName : String = ""
    static var lastName : String = ""
    
    //End Points
    enum Endpoints {
        
        //MARK: all end points (APIs)
        case login
        case signUp
        case getStudentsLocation
        case postStudentLocation
        case getFristandLastName(String)
        
        var stringValue: String {
            switch self {
            case .login: return "https://onthemap-api.udacity.com/v1/session"
                
            case .signUp: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
                
            case .getStudentsLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
                
            case .getFristandLastName(let userId): return "https://onthemap-api.udacity.com/v1/users/\(userId)"
                
            }
        }
        
        //MARK: URL Objects
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
    }
    //MARK: - Post username and password to login
    class func login(username:String, password:String, completion: @escaping (String?, Error?)->()){
        
        let url = Endpoints.login.url
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        // call task for Post Request
        taskForPOSTRequest(url: url, responseType: User.self, body: body, skip: true) { (response, error) in
            if let response = response{
                APICalls.accountUniqeKey = response.account.key
                completion(APICalls.accountUniqeKey,nil)
                
            }else{
                completion(nil,error)
            }
        }
    }
    
    //MARK: - post Student Location
    class func postStudentLocation(mapString:String,mediaURL:String,lat:Double,log:Double, completion: @escaping (String?,Error?) -> Void){
        
        let url = Endpoints.postStudentLocation.url
        
        //Body
        let body = "{\"uniqueKey\": \"\(APICalls.accountUniqeKey)\", \"firstName\": \"\(fristName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(log)}".data(using: .utf8)
        
        
        // call task for Post Request
        taskForPOSTRequest(url: url, responseType: PostStudentLocationResponse.self, body: body, skip: false) { (response, error) in
            
            if let response = response{
                completion("Susses",nil)
            }else{
                completion(nil,error)
            }
        }
        
    }
    
    //MARK: - Post Requests
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, skip:Bool, completion: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod="POST"
        
        //JSON format
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body as? Data
        
        //Send the Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let res = (response as? HTTPURLResponse)?.statusCode else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            
            guard var data = data else{
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return }
            
            //Skipping the first 5 characters
            if skip {
                data = data.subdata(in: 5..<data.count) }
            
            //Parsing JSON Obj
            
            do{
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(responseType , from: data)
                DispatchQueue.main.async{
                    completion(responseObject , nil)
                }
            }catch{
                DispatchQueue.main.async{
                    completion(nil,error)
                }
            }
        }
        
        task.resume()
        
    }
    
    //MARK: - get Student Locations
    class func getSudentsLocation(completion: @escaping ([StudentLocation],Error?) -> Void){
        
        let request = URLRequest(url: Endpoints.getStudentsLocation.url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion([],error)
                }
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
            } catch {
                
                DispatchQueue.main.async {
                    completion([], error)
                }
                
            }
        }
        
        task.resume()
    }
    //MARK: - Get Frist and Last name
    class func getFristandLastName(ompletion: @escaping(Bool , Error?) -> Void){
        let request = URLRequest(url: Endpoints.getFristandLastName(self.accountUniqeKey).url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                
                ompletion(false,error)
                return
            }
            
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                let dict = json as? [String:Any],
                let fristName = dict["last_name"] as? String,
                let lastName = dict["first_name"] as? String{
                self.fristName=fristName
                self.lastName=lastName
                ompletion(true,nil)
            }else{
                ompletion(false,error)
            }
            
        }
        task.resume()
    }
    
    
    //MARK: -Logout Request Delete Session id
    class func logout ( completion: @escaping(Bool , Error?) -> Void ){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false,error)
                return
            }
            
            completion(true,nil)
        }
        task.resume()
    }
    
    
    
}//End Class

