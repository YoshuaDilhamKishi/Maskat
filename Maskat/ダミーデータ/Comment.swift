//
//  Comment.swift
//  Twitter
//
//  Created by Ryosuke Fukuda on 8/15/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit
import Parse

//どこでも使えるクラス
public class Comment: PFObject, PFSubclassing {
    
    
    @NSManaged public var postId: String!
    @NSManaged public var user: PFUser
    @NSManaged public var commentText: String!
    
    //Public API
    
    var post: Post!
    
    override init() {
        super.init()
    }
    
    
    //create new comment
    
    init(postId: String, user: PFUser, commentText: String) {
        
        self.postId = postId
        self.user = user
        self.commentText = commentText
        
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
        
        return "Comment"
        
    }
    
    
    
    
    
}