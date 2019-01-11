//
//  TableViewController.swift
//  OnTheMap
//
//  Created by MAC on 04/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TableViewController: SharedViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
   var networkObjectSub = NetworkMethod()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkObjectSub.getStudentLocation { (success, message, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                if error != nil || !message.isEmpty {
                    self.showAlert(message: "Failed to download students locations")
                }
            }
    }

}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllStudentLocations.studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath)
        cell.textLabel?.text = "\(AllStudentLocations.studentsLocations[indexPath.row].firstName) \(AllStudentLocations.studentsLocations[indexPath.row].lastName)"
        cell.detailTextLabel?.text = "\(AllStudentLocations.studentsLocations[indexPath.row].mediaURL)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    UIApplication.shared.open(NSURL(string:AllStudentLocations.studentsLocations[indexPath.row].mediaURL)! as URL)
    }
    override func refreshTapped() {
        tableView.reloadData()
    }
}
