//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by MAC on 01/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    var networkObject = NetworkMethod()
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if let username = emailTextField?.text ,let password = passwordTextField?.text {
        networkObject.login(username: username, password: password) { (success, message, error) in
            if success == true {
            DispatchQueue.main.async {
                let mapController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarController") as! UITabBarController
                self.present(mapController, animated: true, completion: nil)
            }
        }
    }
        } else {print("Please insert your email and password")}
}
        
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://auth.udacity.com/sign-up")! as URL)
    }
}

