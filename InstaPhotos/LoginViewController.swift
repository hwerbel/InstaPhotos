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
        //Round corners of logo
        logoView.layer.cornerRadius = 5
        logoView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            //No errors
            if user != nil {
                print("logged in")
                //Segue to home screen
                self.performSegueWithIdentifier("toHome", sender: nil)
            
            //Error Signing in
            } else {
                //Invalid user name or password
                if error!.code == 101 {
                    //Show alert
                    let alertController = UIAlertController(title: "Error", message: "Invalid Username or Password",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                //Other error
                } else {
                    //Show alert
                    let alertController = UIAlertController(title: "Error", message: "Error Logging In: CHeck XCode comsol for more details",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                //clear text fields
                self.userNameField.text = ""
                self.passwordField.text = ""
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        //Get user name and password from text fields
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("user created")
                //Segue to home screen
                self.performSegueWithIdentifier("toHome", sender: nil)
            
            //Failure
            } else {
                print(error?.localizedDescription)
                //If user name already exists
                if error!.code == 202 {
                    //Show alert
                    let alertController = UIAlertController(title: "Error", message: "Username already exists",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                //Other error
                } else {
                    //show alert
                    let alertController = UIAlertController(title: "Error", message: "Error Sigining Up: Check XCode comsol for more details",preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                //Clear text fields
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
