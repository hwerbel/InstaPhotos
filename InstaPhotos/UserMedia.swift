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
    
    class func postUserImage(image: UIImage?, caption: String?) {
        let media = PFObject(className: "userMedia")
        media["media"] = getPFFileFromImage(image)
        media["author"] = PFUser.currentUser()
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        
        media.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("successfully saved image")
            } else {
                print("did not save image")
            }
        }
    }
    
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
    
    class func getPosts(predicate: String?, completion: (posts: [PFObject]?, error: NSError?) -> ()) {
        var query: PFQuery
        if predicate != nil {
            let predicate = NSPredicate(format: predicate!)
            query = PFQuery(className: "UserMedia", predicate: predicate)
        } else {
            query = PFQuery(className: "UserMedia")
        }
        query.orderByDescending("_created_at")
        
        query.findObjectsInBackgroundWithBlock{ (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                completion(posts: media, error: nil)
                print(media)
                print("got media")
            } else {
                completion(posts: nil, error: error)
                print("failed to get media")
            }
        }
    }
}
