//
//  CommentViewController.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/25.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import UIKit
import Parse

class CommentViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var newButton: ActionButton!
    
    
    
    
    
    //APIからの情報取得（commentdotswift）
    var comments = [Comment]()
    
    
    //クリックされたコメントの表示
    var post: Post!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //せるのサイズを調整するよ
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        

        //NavigationBarデザイン
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#90d52e")
        
        let nib = UINib(nibName: "PostInCommentTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "postInCommentCell")
        
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.registerNib(nib2, forCellReuseIdentifier: "commentCell")
        
        createNewButton()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        super.viewWillAppear(animated)
        fetchComment()
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        
        center.addObserverForName("NewCommentSent", object: nil, queue: queue) { (notification) -> Void in
            
            if let newComment = notification.userInfo?["newCommentObject"] as? Comment {
                if !self.postWasDisplayed(newComment){
                    
                    self.comments.insert(newComment, atIndex: 0)
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    func postWasDisplayed(newCooment: Comment) -> Bool {
        
        for comment in comments{
            if comment.objectId! == newCooment.objectId! {
                return true
            }
            
        }
        return false
        }
    

        //ボタンの実装
        private func createNewButton(){
        
        newButton = ActionButton(attachedToView: self.view, items: [])
        newButton.action = { button in
            print ("Post Button Pressed")
            
            self.performSegueWithIdentifier("New Comment Composer", sender: self)
            
        }
        
        newButton.backgroundColor = UIColor.greenColor()
        
        
    }
    
    func fetchComment() {
        
        let commentQuery = PFQuery(className: Comment.parseClassName())
        
        commentQuery.whereKey("postId", equalTo: post.objectId!)
        commentQuery.orderByAscending("updateAt")
        commentQuery.includeKey("user")
        
        
        commentQuery.findObjectsInBackgroundWithBlock { (optionalObjects, error) -> Void in
            if error == nil{
                
                if let commentObjects = optionalObjects as? [PFObject] {
                    
                    // とってきたデータがゼロだったら表示されないようにする
                    if commentObjects.count > 0 {
                     
                        self.comments.removeAll(keepCapacity: false)
                        
                        for commentObject in commentObjects {
                            
                            let comment = commentObject as! Comment
                            self.comments.append(comment)
                        }
                        
                    }
                    
                    
                }
                self.tableView.reloadData()
                
            } else {
               print("\(error?.localizedDescription)")
            }
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "New Comment Composer"{
            
            let newCommentComposerViewController = segue.destinationViewController as! NewCommentViewController
            newCommentComposerViewController.post = post
            
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}






extension CommentViewController: UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comments.count+1)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("postInCommentCell", forIndexPath: indexPath) as! PostInCommentTableViewCell
            
            cell.post = post
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            
            cell.comment = comments[indexPath.row-1]
            
            return cell
        }
        
        
    }
    
    
}