//
//  tabBarViewController.swift
//  InstaPhotos
//
//  Created by user116674 on 2/29/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse

class tabBarViewController: UITabBarController {
    //Variable that can be accessed between tabs--used to control which user's profile to show on the profile page
    var profileUser = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Customize tabBar
        UITabBar.appearance().tintColor = UIColor.greenColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
