//
//  TableViewController.swift
//  OnTheMap
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func generateList() {
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.shared.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Student")!
        let row = StudentInformation.shared.students[(indexPath as NSIndexPath).row]
        
        cell.textLabel!.text = "\(row.firstName) \(row.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text = row.mediaUrl
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = StudentInformation.shared.students[(indexPath as NSIndexPath).row]
        
        if let url = URL(string: "\(row.mediaUrl)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
