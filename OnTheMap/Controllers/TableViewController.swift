//
//  TableViewController.swift
//  OnTheMap
//
//  Created by MAC on 04/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TableViewController: SharedViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   
    var networkObject = NetworkMethod()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkObject.getStudentLocation { (success, message, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {print("data load faild")}
    }

}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkObject.appDelegate!.studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath)
        cell.textLabel?.text = "\(networkObject.appDelegate!.studentsLocations[indexPath.row].firstName) \(networkObject.appDelegate!.studentsLocations[indexPath.row].lastName)"
        cell.detailTextLabel?.text = "\(networkObject.appDelegate!.studentsLocations[indexPath.row].mediaURL)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    UIApplication.shared.open(NSURL(string:networkObject.appDelegate!.studentsLocations[indexPath.row].mediaURL)! as URL)
    }
    
}
