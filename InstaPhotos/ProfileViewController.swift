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

    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var imageToUpload: UIImage?
    var currentUser = PFUser.currentUser()
    var profileUser: PFUser?
    var user: PFUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController! as! tabBarViewController
        profileUser = tbvc.profileUser
        if profileUser != nil {
            user = profileUser
            if profileUser != currentUser {
                updateButton.hidden = true
            }
        } else {
            user = currentUser
        }
        userNameLabel.text = user!["username"] as? String
        let createdAt = user!.createdAt!
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        self.createdAtLabel.text = formatter.stringFromDate(createdAt)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didEndUpload:"), name: "EndProfileUpload", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let imageFile = user!["profilePic"] as? PFFile {
            self.profileImageView.file = imageFile
            self.profileImageView.loadInBackground()
        } else {
            self.profileImageView.image = UIImage(named: "flower.png")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpdateProfilePic(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageToUpload = resize(image, newSize: CGSizeMake(750, 750))
            self.profileImageView.image = self.imageToUpload
            self.dismissViewControllerAnimated(true, completion: nil)
            self.view.alpha = 0.7
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Updating"
            UserMedia.postProfileImage(self.imageToUpload)
    }
    
    func didEndUpload(notification: NSNotification) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.view.alpha = 1
    }
    
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
