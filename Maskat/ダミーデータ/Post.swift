//
//  Post.swift
//  Twitter
//
//  Created by Ryosuke Fukuda on 8/15/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

//どこでも使えるクラス
public class Post: PFObject, PFSubclassing {
    
   
    //Public API
    
    @NSManaged public var user: PFUser //絶対にPFじゃないとだめだお
    @NSManaged public var postImage: PFFile
    @NSManaged public var postText: String!
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var LikedUserIds: [String]!
    
    //Create Newpost
    
    init(user: PFUser, postImage: UIImage, postText: String, numberOfLikes: Int) {
        
        override init() {
            super.init()
        }
        //postImage = postImage
        
        postImageFile = createFileForm(postImage)
        
        self.user = user
        self.postText = postText
        self.numberOfLikes = numberOfLikes
        self.LikedUserIds=[String]()
        
        
    }
    
    
    
    

    
    //PFsubのときに書く
    override public class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            
        }
        
        dispatch_once(&Static.onceToken) {
            
            self.registerSubclass()
            
        }
        
    }
    
    public static func parseClassName() -> String {
        
        return "Post"
        
    }
    
    

    
    
}