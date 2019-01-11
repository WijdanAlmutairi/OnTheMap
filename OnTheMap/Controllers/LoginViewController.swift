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
    var myKeyboard = Keyboard()
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myKeyboard.configureTextField(textField: passwordTextField!)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if let username = emailTextField?.text ,let password = passwordTextField?.text {
            networkObject.login(username: username, password: password) { (success, message, error) in
            if success == true {
            DispatchQueue.main.async {
                let mapController = self.storyboard?.instantiateViewController(withIdentifier: "TapBarController") as! UITabBarController
                self.present(mapController, animated: true, completion: nil)
            }
            }else {
                if error != nil {
                    self.showAlert (message: "Please check your internet connection")
                }else if message.contains("2xx"){
                    self.showAlert (message: "Invalid email or password")
                 }
                }
    }
        } else {print("Please insert your email and password")}
}
        
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://auth.udacity.com/sign-up")! as URL)
    }
}

