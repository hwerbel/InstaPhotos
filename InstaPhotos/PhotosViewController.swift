//
//  PhotosViewController.swift
//  InstaPhotos
//
//  Created by user116136 on 2/26/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class PhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var captionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var uploadView: UIView!
    let uploadTap = UITapGestureRecognizer()
    var imageToUpload: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up views
        initialView()
        
        //Progress HUD
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didSaveImage:"), name: "EndUpload", object: nil)
        
        //Monitor Keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardIsShowing:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Set current user as profileUser
        (self.tabBarController! as! tabBarViewController).profileUser = PFUser.currentUser()!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialView() {
        //Visual layout
        previewImageView.image = nil
        previewImageView.hidden = true
        uploadView.alpha = 0.8
        doneButton.hidden = true
        uploadLabel.hidden = false
        captionTextView.delegate = self
        captionTextView.text = ""
        captionLabel.hidden = false
        
        //Tap Gesture Recognizer
        uploadTap.addTarget(self, action: Selector("onUploadTap:"))
        uploadView.addGestureRecognizer(uploadTap)
        uploadView.userInteractionEnabled = true
    }
    
    func textViewDidChange(textView: UITextView) {
        let charCount = textView.text.characters.count
        
        //Check character count to decide whether to hide caption placeholder label
        if charCount > 0 {
            self.captionLabel.hidden = true
        } else {
            self.captionLabel.hidden = false
        }
    }
    
    func keyboardIsShowing(notification: NSNotification) {
        var keyboardInfo = notification.userInfo!
        let keyboardFrame: CGRect = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //Move caption text field up when keyboard pops up
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.captionViewBottomConstraint.constant = keyboardFrame.size.height - 50
        })
        
        //Dim background
        self.uploadView.alpha = 0.7
        
        //SHow done button
        doneButton.hidden = false
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //Move caption text field back down
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.captionViewBottomConstraint.constant = 63
        })
        
        //Un-dim background
        self.uploadView.alpha = 1.0
        
        //Hide done button
        doneButton.hidden = true
    }
    
    //Upload image tapped
    func onUploadTap(recognizer: UITapGestureRecognizer) {
        //Open image picker
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            //Get image from image picker
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageToUpload = resize(image, newSize: CGSizeMake(750, 750))
            
            //Show image in preview image view
            self.previewImageView.image = self.imageToUpload
            self.previewImageView.hidden = false
            self.uploadLabel.hidden = true
            self.uploadView.alpha = 1
            
            //Dismiss image picker
            self.dismissViewControllerAnimated(true, completion: nil)
            
            //Remove tap gesture recognizer from upload view
            uploadView.removeGestureRecognizer(uploadTap)
    }
    
    //Resize image to fit in Parse's limits
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
    
    @IBAction func onDone(sender: AnyObject) {
        //End editing of caption
        self.captionTextView.endEditing(true)
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        //Customize loading indicator
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading Image"
        
        //Upload image
        UserMedia.postUserImage(self.imageToUpload!, caption: captionTextView.text!)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        //Return to initial views
        initialView()
        
        //Return to home page
        self.tabBarController!.selectedIndex = 0
    }
    
    func didSaveImage(notification: NSNotification) {
        //Stop loading indicator
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        //Return to initial views
        initialView()
        
        //Return to home page
        self.tabBarController!.selectedIndex = 0
        
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
