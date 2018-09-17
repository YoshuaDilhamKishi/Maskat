//
//  PostInCommentTableViewCell.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/25.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import UIKit


class PostInCommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    
    
    var post: Post! {
        didSet{
            updateUI()
        }
    }
    
    private var currentUserDidLike: Bool =  false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        
        post.postImageFile.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            if let featuredImage = imageData {
                
                self.postImage! = UIImage(data: featuredImage)
            }
            
        }
        usernameLabel.text! = post.user.username!
        createdAt.text! = post.createdAt
        
        postText.text! = post.postText
        
        likeButton.setTitle("😃 \(post.numberOfLikes) Likes", forState: .Normal)
        
        changeLikeButtonColor()
        configureButtonAppearence()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width/2
        profileImage.clipsToBounds = true
            
        postImage.layer.cornerRadius = 5.0
            
    
    }
    
    
    private func configureButtonAppearence() {
        
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 2.0
        likeButton.borderColor = UIColor.lightGrayColor()
        likeButton.tintColor = UIColor.lightGrayColor()
        
    }
    
    
    private func changeLikeButtonColor(){
        
        if currentUserDidLike{
            
            
            likeButton.borderColor = UIColor(hex: "#00b0ac")
            likeButton.tintColor = UIColor(hex: "#00b0ac")
        } else {
            
            likeButton.borderColor = UIColor.lightGrayColor()
            likeButton.tintColor = UIColor.lightGrayColor()
        }
        
        
    }

    
    
    
    @IBAction func likeButton_Clicked(sender: DesignableButton) {
        
        post.userDidLike = !post.userDidLike
        if post.userDidLike{
            post.numberOfLikes++
        } else{
            post.numberOfLikes--
        }
        
        likeButton.setTitle("😃 \(post.numberOfLikes) Likes", forState: .Normal)
        
        currentUserDidLike = post.userDidLike
        
        changeLikeButtonColor()
        //animation
        
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
    }
  
    
}
