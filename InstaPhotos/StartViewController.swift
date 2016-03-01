//
//  StartViewController.swift
//  InstaPhotos
//
//  Created by user116136 on 2/26/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() != nil {
            //segue to home screen
            self.performSegueWithIdentifier("toHomeSegue", sender: nil)
            print("current user detected")
        } else {
            //segue to login screen
            self.performSegueWithIdentifier("toLoginSegue", sender: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
