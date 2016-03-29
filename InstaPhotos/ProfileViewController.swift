//
//  ProfileViewController.swift
//  InstaPhotos
//
//  Created by user116136 on 2/28/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var imageToUpload: UIImage?

    var user: PFUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Watch for end of profile image upload
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didEndUpload:"), name: "EndProfileUpload", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Get user's profile to show
        user = (self.tabBarController as! tabBarViewController).profileUser
        
        //Disable current user features if profile does not belong to current user
        if user!.username != PFUser.currentUser()!.username {
            updateButton.hidden = true
            logoutButton.hidden = true
        //Show current user features if profile does belong to current user
        } else {
            updateButton.hidden = false
            logoutButton.hidden = false
        }
        
        //Set user name
        userNameLabel.text = user!.username
        
        //Format createdAt
        let createdAt = user!.createdAt!
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        self.createdAtLabel.text = formatter.stringFromDate(createdAt)
        
        //If user has a profile picture
        if let imageFile = user!["profilePic"] as? PFFile {
            self.profileImageView.file = imageFile
            self.profileImageView.loadInBackground()
        //If user does not have a profile picture, use default
        } else {
            self.profileImageView.image = UIImage(named: "flower.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpdateProfilePic(sender: AnyObject) {
        //Display image picker
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            //Get image from image picker and upload
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageToUpload = resize(image, newSize: CGSizeMake(750, 750))
            self.profileImageView.image = self.imageToUpload
            
            //Dismiss image picker
            self.dismissViewControllerAnimated(true, completion: nil)
            
            //Dim background while uploading
            self.profileView.alpha = 0.7
            
            //Customize loading indicator
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Updating"
            UserMedia.postProfileImage(self.imageToUpload)
    }
    
    func didEndUpload(notification: NSNotification) {
        //Stop loading indicator
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        //Brighten background to normal state
        self.profileView.alpha = 1
    }
    
    //Resize image to fit Parse limits
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        //Log user out
        PFUser.logOut()
        print(PFUser.currentUser())
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
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
