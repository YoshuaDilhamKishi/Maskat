//
//  NewCommentViewController.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/26.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import UIKit
import Parse

class NewCommentViewController: UIViewController {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var comment = [User]()
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.barTintColor = UIColor(hex: "#90d52e")
        
        
        
        commentText.text = ""
        commentText.becomeFirstResponder()
        
        profileImage.image = user.profileImage
        usernameLabel.text! = User.currentUser()!.username!
        
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width/2
        profileImage.clipsToBounds = true
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton_Clicked(sender: AnyObject) {
        
        commentText.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func commentButton_Clicked(sender: AnyObject) {
        
        
        postNewComment()
        
        
        
        commentText.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    func postNewComment(){
        
        
        
        let newComment = Comment(postId: post.objectId!, user: User.currentUser()!, commentText: commentText.text!)
        newComment.saveInBackgroundWithBlock { (success, error) -> Void in
         
            if error == nil {
                print("comment sent")

                //local notification
                
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: "NewCommentSent", object: nil, userInfo: ["newCommentObject" : newComment])
                center.postNotification(notification)

                
                
            } else {
                print("\(error?.localizedDescription)")
                
            }
            
            
        }
        
        
        
    }
    
}
