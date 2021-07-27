//
//  TableViewController.swift
//  Instagram
//
//  Created by harshvardhan singh on 8/22/19.
//  Copyright © 2019 harshvardhan singh. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var userNames = [""]
    var objectIds = [""]
    var isFollowing = ["": false]
    
    var refresher: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadTable()
        
        //refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(TableViewController.reloadTable), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
    }

    // MARK: - Table view data source

    @objc func reloadTable() {
        
        let query = PFUser.query()
        
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        
        query?.findObjectsInBackground(block: { (users, Error) in
            
            if Error != nil{
                
                print("Error")
                
            }else if let users = users{
                
                self.userNames.removeAll()
                self.objectIds.removeAll()
                self.isFollowing.removeAll()
                
                for profiles in users{
                    
                    if let user = profiles as? PFUser{
                        
                        if let username = user.username{
                            
                            if let objectId = user.objectId{
                                
                                let usernamesArray = username.components(separatedBy: "@")
                                
                                self.userNames.append(usernamesArray[0])
                                self.objectIds.append(objectId)
                                
                                let query = PFQuery(className: "Following")
                                
                                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                                query.whereKey("following", equalTo: objectId)
                                
                                query.findObjectsInBackground(block: { (object, error) in
                                    
                                    if object != nil{
                                        
                                        if object!.count > 0 {
                                            
                                            self.isFollowing[objectId] = true
                                            
                                        }else {
                                            
                                            self.isFollowing[objectId] = false
                                            
                                        }
                                        
                                        if self.userNames.count == self.isFollowing.count{
                                            
                                            self.tableView.reloadData()
                                            self.refresher.endRefreshing()
                                            
                                        }
                                        
                                    }
                                    
                                })
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = userNames[indexPath.row]
        
        if let follows = isFollowing[objectIds[indexPath.row]] {
            
            if follows {
                
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                
            }

        }
        
        return cell
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "logout", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let follows = isFollowing[objectIds[indexPath.row]] {
            
            if follows {
                
                isFollowing[objectIds[indexPath.row]] = false
                
                cell?.accessoryType = UITableViewCell.AccessoryType.none
                
                let query = PFQuery(className: "Following")
                
                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                query.whereKey("following", equalTo: objectIds[indexPath.row])
                
                query.findObjectsInBackground(block: { (object, error) in
                    
                    if let objects = object{
                        
                        for objects in objects{
                            
                            objects.deleteInBackground()
                            
                        }
                        
                    }
                        
                        self.tableView.reloadData()
                        
                    })
            
        }else{
                
                isFollowing[objectIds[indexPath.row]] = true
            
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
                let following = PFObject(className: "Following")
            
                following["follower"] = PFUser.current()?.objectId
            
                following["following"] = objectIds[indexPath.row]
            
                following.saveInBackground()
            
        }
        }
     
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
