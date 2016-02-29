//
//  HomeViewController.swift
//  InstaPhotos
//
//  Created by user116136 on 2/26/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, profileTapDelegate{

    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject]?
    var post: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        let tbvc = self.tabBarController! as! tabBarViewController
        tbvc.profileUser = nil
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        UserMedia.getPosts(nil, completion: { (posts, error) -> () in
            self.posts = posts!
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
            return posts!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.post = posts![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaCell", forIndexPath: indexPath) as! InstaCell
        cell.delegate = self
        cell.post = posts![indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
    
    
    func didTapProfile(user: PFUser?) {
        let tbvc = self.tabBarController as! tabBarViewController
        tbvc.profileUser = user
        self.tabBarController!.selectedIndex = 2
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
