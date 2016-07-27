//
//  BackTableVC.swift
//  Agua
//
//  Created by Edgar Trujillo on 3/26/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SafariServices


class BackTableVC: UITableViewController {
    
    var TableArray = [String]()

    private var urlString:String = "https://www.aguapoints.org"
    
    @IBAction func openWithSafariVC(sender: AnyObject)
    {
        let svc = SFSafariViewController(URL: NSURL(string: self.urlString)!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    
    

    
    
    override func viewDidLoad() {
        TableArray = ["Home","Shop","Share","More Points","Help", "Settings"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
    }
    
    
    
    
    
}