//
//  NetworkMethod.swift
//  OnTheMap
//
//  Created by MAC on 06/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class NetworkMethod: UIViewController {

    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    //var alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    func getStudentLocation (_ completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
        
        let methodParameters = [Constants.ParseParameterKeys.studentsMax: Constants.ParseParameterValues.studentsMaxNumber, Constants.ParseParameterKeys.studentOrder: Constants.ParseParameterValues.studentChosenOrder]
        
    if let appDelegate = appDelegate {
        var request = URLRequest(url: appDelegate.parseURLFromParameter(methodParameters as [String : AnyObject], withPathExtension: "/StudentLocation"))
        
        request.addValue(Constants.ParseParameterKeys.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseParameterKeys.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = appDelegate.sharedSession.dataTask(with: request){ (data, response, error) in
            
            guard (error == nil) else {
                completionHandler (false, "", error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler (false, "Your request returned a status code other than 2xx!", error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler (false, "No data was returned by the request!", error)
    
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                
            } catch {
                completionHandler (false, "Could not parse the data as JSON: '\(data)'", error)
                return
            }
            
            guard let studentsLocationResults = parsedResult["results"] as? [[String: AnyObject]] else {
                completionHandler (false, "Cannot find key 'results' in \(String(describing: parsedResult))", error)
                return
            }
            self.convertToStruct (studentDictionary: studentsLocationResults)
            completionHandler (true, "", nil)
        }
        task.resume()
       }
    }



    func login (username: String, password: String, completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
    let methodParameters = [Constants.UdacityParameterKeys.username: username, Constants.UdacityParameterKeys.password: password]
        if let appDelegate = appDelegate {
            var request = URLRequest(url: appDelegate.udacityURLFromParameter(methodParameters as [String : AnyObject], withPathExtension: "/session"))
    
    request.httpMethod = "POST"
    request.addValue("applicatio/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    
    let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
        
        guard (error == nil) else {
            completionHandler (false, "", error)
            return
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
             completionHandler (false, "Your request returned a status code other than 2xx!", error)
            return
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            completionHandler (false, "No data was returned by the request!", error)
            return
        }
        
        let range = (5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String:AnyObject]
            
        } catch {
            completionHandler (false, "Could not parse the data as JSON: '\(newData)'", error)
            return
        }
        
        guard let account = parsedResult [Constants.UdacityResponseKeys.userAccount] as? [String: AnyObject] else {
            completionHandler (false, "Cannot find key '\(Constants.UdacityResponseKeys.userAccount)' in \(String(describing: parsedResult))", error)
            return
        }
        guard let userID = account[Constants.UdacityResponseKeys.userID] as? String  else {
            completionHandler (false, "Cannot find key '\(Constants.UdacityResponseKeys.userID)' in \(account)", error)
            return
        }
        
        self.appDelegate!.UserID = userID
         completionHandler (true, "", nil)
    }
    task.resume()
    }
}
    func postStudentLocation (studentLocation: StudentInformation, completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
        
        var location = studentLocation
        
        if let appDelegate = appDelegate {
            var request = URLRequest(url: appDelegate.parseURLFromParameter([:] as [String : AnyObject], withPathExtension: "/StudentLocation"))
        request.httpMethod = "POST"
        request.addValue(Constants.ParseParameterKeys.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseParameterKeys.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(studentLocation.uniqueKey)\", \"firstName\": \"Dan\", \"lastName\": \"Cooper\",\"mapString\": \"\(studentLocation.mapString)\", \"mediaURL\": \"\(studentLocation.mediaURL)\",\"latitude\": \(studentLocation.latitude), \"longitude\": \(studentLocation.longitude)}".data(using: .utf8)

        let task = appDelegate.sharedSession.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completionHandler (false, "", error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler (false, "Your request returned a status code other than 2xx!", error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler (false, "No data was returned by the request!", error)
                
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
                
            } catch {
                completionHandler (false, "Could not parse the data as JSON: '\(data)'", error)
                return
            }
            
            guard let studentsLocationDate = parsedResult["createdAt"] as? String else {
                completionHandler (false, "Cannot find key 'createdAt' in \(String(describing: parsedResult))", error)
                return
            }
            guard let studentsLocationID = parsedResult["objectId"] as? String else {
                completionHandler (false, "Cannot find key 'objectId' in \(String(describing: parsedResult))", error)
                return
            }
            location.createdAt = studentsLocationDate
            location.objectId = studentsLocationID
            appDelegate.studentsLocations.append(location)
            completionHandler (true, "", nil)
        }
        task.resume()
    }

    }
func convertToStruct (studentDictionary: [[String: AnyObject]] ){
    
    for studentLocation in studentDictionary {
        // Condition required to check for type safety :)
        let createdAt = studentLocation["createdAt"] as! String
        let firstName = studentLocation["firstName"] as! String
        let lastName = studentLocation["lastName"] as! String
        let latitude = studentLocation["latitude"] as! Double
        let longitude = studentLocation["longitude"] as! Double
        let mapString = studentLocation["mapString"] as! String
        let mediaURL = studentLocation["mediaURL"] as! String
        let objectId = studentLocation["objectId"] as! String
        let uniqueKey = studentLocation["uniqueKey"] as! String
        let updatedAt = studentLocation["updatedAt"] as! String
        
        let studentObject = StudentInformation(createdAt: createdAt, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectId: objectId, uniqueKey: uniqueKey, updatedAt: updatedAt)
            appDelegate!.studentsLocations.append(studentObject)
        
    }
}

}
