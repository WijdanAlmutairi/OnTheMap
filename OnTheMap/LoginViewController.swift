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
        
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
    }
}

