//
//  PostTableViewCell.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/22.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate {
    
    func commentButton_Clicked(post: Post)
    
}

class PostTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    
    @IBOutlet weak var likeButton: DesignableButton!
    @IBOutlet weak var commentButton: DesignableButton!
    
    
    private var currentUserDidLike: Bool =  false
    
    var delegate: PostTableViewCellDelegate!
    
    
    
    var post: Post! {
        
        didSet{
            updateUI()
        }
        
    }
    
    private func updateUI(){
        
        //画像を丸める
        
        userProfilePic.layer.cornerRadius = userProfilePic.layer.bounds.width/2
        postImage.layer.cornerRadius = 5.0
        
        userProfilePic.clipsToBounds = true
        postImage.clipsToBounds = true
        
       
        
        //表示させていくよ
        
        post.postImage.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil{
                
                if let featuredImageData = imageData {
                    
                    self.postImage.image = UIImage(data: featuredImageData)
                    
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
        }

        
        
        usernameLabel.text = post.user.username!
        createdAt.text! = post.createdAt
        postText.text! = post.postText
        
        
        likeButton.setTitle("😃 \(post.numberOfLikes) Likes", forState: .Normal)
        
        configureButtonAppearence()
        changeLikeButtonColor()
        
    }
    
    
    private func configureButtonAppearence() {
        
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 2.0
        likeButton.borderColor = UIColor.lightGrayColor()
        likeButton.tintColor = UIColor.lightGrayColor()
        
        commentButton.cornerRadius = 3.0
        commentButton.borderWidth = 2.0
        commentButton.borderColor = UIColor.lightGrayColor()
        commentButton.tintColor = UIColor.lightGrayColor()
        
        
        
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
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    
    @IBAction func commentButton_Clicked(sender: DesignableButton) {
        
        //animation
        
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        delegate?.commentButton_Clicked(post)
        
        
    }
}
