//
//  LoginViewController.swift
//  InstaPhotos
//
//  Created by user116136 on 2/26/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.layer.cornerRadius = 5
        logoView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("logged in")
                self.performSegueWithIdentifier("toHome", sender: nil)
            } else {
                if error!.code == 101 {
                    let alertController = UIAlertController(title: "Error", message: "Invalid Username or Password",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Error Logging In: CHeck XCode comsol for more details",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                self.userNameField.text = ""
                self.passwordField.text = ""
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("user created")
                self.performSegueWithIdentifier("toHome", sender: nil)
            } else {
                print(error?.localizedDescription)
                if error!.code == 202 {
                    let alertController = UIAlertController(title: "Error", message: "Username already exists",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Error Sigining Up: Check XCode comsol for more details",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                self.userNameField.text = ""
                self.passwordField.text = ""
            }
        }
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
