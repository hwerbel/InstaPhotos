//
//  UserMedia.swift
//  InstaPhotos
//
//  Created by user116136 on 2/26/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    
    //Upload profile picture
    class func postProfileImage(image: UIImage?) {
        let user = PFUser.currentUser()!
        user["profilePic"] = getPFFileFromImage(image)
        
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("successfully updated profile image")
            } else {
                print("did not update profile image")
            }
            NSNotificationCenter.defaultCenter().postNotificationName("EndProfileUpload", object: nil)
        }
    }
    
    //Post uploaded image
    class func postUserImage(image: UIImage?, caption: String?) {
        let userMedia = PFObject(className: "userMedia")
        //Assign properties to userMedia class
        userMedia["media"] = getPFFileFromImage(image)
        userMedia["author"] = PFUser.currentUser()
        userMedia["username"] = PFUser.currentUser()!.username
        userMedia["caption"] = caption
        userMedia["likesCount"] = 0
        userMedia["commentsCount"] = 0
        
        userMedia.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("successfully saved image")
            } else {
                print("did not save image")
            }
            NSNotificationCenter.defaultCenter().postNotificationName("EndUpload", object: nil)
        }
    }
    
    //Convert image to storabl PFFile
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                print("got image")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        print("could not get image")
        return nil
    }
    
    //Get recent posts to show in feed
    class func getPosts(predicate: String?, completion: (posts: [PFObject]?, error: NSError?) -> ()) {
        var query: PFQuery
        //If query includes a predicate
        if predicate != nil {
            let predicate = NSPredicate(format: predicate!)
            query = PFQuery(className: "userMedia", predicate: predicate)
        //If query does not include a predicate
        } else {
            query = PFQuery(className: "userMedia")
        }
        //Include "author" key in query
        query.includeKey("author")
        //List most recent posts first
        query.orderByDescending("_created_at")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock{ (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                completion(posts: media, error: nil)
                print("got media")
            } else {
                completion(posts: nil, error: error)
                print("failed to get media")
            }
        }
    }
}
