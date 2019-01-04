//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by MAC on 01/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let methodParameters = [Constants.UdacityParameterKeys.username: emailTextField.text!, Constants.UdacityParameterKeys.password: passwordTextField.text!]
        
        var request = URLRequest(url: appDelegate.udacityURLFromParameter(methodParameters as [String : AnyObject], withPathExtension: "/session"))
        
        request.httpMethod = "POST"
        request.addValue("applicatio/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(emailTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        
        let task = appDelegate.sharedSession.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print ("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print ("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print ("No data was returned by the request!")
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String:AnyObject]
                
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            guard let session = parsedResult [Constants.UdacityResponseKeys.session] as? [String: AnyObject] else {
               print ("Cannot find key '\(Constants.UdacityResponseKeys.session)' in \(parsedResult)")
                return
            }
            guard let sessionID = session[Constants.UdacityResponseKeys.sessionID] as? String  else {
                print ("Cannot find key '\(Constants.UdacityResponseKeys.sessionID)' in \(session)")
                return
            }
            
            guard let account = parsedResult [Constants.UdacityResponseKeys.userAccount] as? [String: AnyObject] else {
                print ("Cannot find key '\(Constants.UdacityResponseKeys.userAccount)' in \(parsedResult)")
                return
            }
            guard let userID = account[Constants.UdacityResponseKeys.userID] as? String  else {
                print ("Cannot find key '\(Constants.UdacityResponseKeys.userID)' in \(account)")
                return
            }
            
            self.appDelegate.sessionID = sessionID
            self.appDelegate.UserID = userID
            //print(userID)
             DispatchQueue.main.async {
                let mapController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarController") as! UITabBarController
                self.present(mapController, animated: true, completion: nil)
            }
            
            print(sessionID)
        }
        task.resume()
        
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://auth.udacity.com/sign-up")! as URL)
    }
}

