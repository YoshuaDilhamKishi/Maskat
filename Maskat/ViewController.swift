//
//  ViewController.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/21.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    
    private var newButton: ActionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "postCell")
        
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#90d52e")
        
        title = "Maskat"
        createNewButton()
        
    }
    
    //Viewが表示される前にlet以下を行うよ
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //ログインしてくれてるユーザーの定義
        let user = PFUser.currentUser()
        
        //ログインしているユーザーがいないとき
        if user == nil {
        
            presentLoginViewController()
        
        } else{
            
            //dataの読み込み
            fetchPosts()
            
            //local notification
            
            let center = NSNotificationCenter.defaultCenter()
            let queue = NSOperationQueue.mainQueue()
            
            center.addObserverForName("NewPostCreated", object: nil, queue: queue, usingBlock: { (notification) -> Void in
                
                
                if let newPost = notification.userInfo?["newPostObject"] as? Post {
                    
                    if !self.postWasDisplayed(newPost) {
                        
                        self.posts.insert(newPost, atIndex: 0)
                        self.tableView.reloadData()
                        
                        
                    }
                    
                }
                
                
                
            })
            
            
        }
        
        
        
        
        
    }
    
    
    func postWasDisplayed(newPost: Post) -> Bool{
        
        
        for post in posts {
            
            if post.objectId! == newPost.objectId! {
                
                return true
            }
            
        }
        return false
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fetch the posts with query
    func fetchPosts() {
        
        
        let currentUser = User.currentUser()!
        let postQuery = PFQuery(className: Post.parseClassName())
        postQuery.orderByDescending("upadatedAt")
        postQuery.includeKey("'user")
        postQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            //エラーの場合分け
            if error == nil {
                
                if let postObjects = objects as? [PFObject] {
                    self.posts.removeAll(keepCapacity: false)
                    for postObject in postObjects {
                        
                        let postItem = postObject as! Post
                        self.posts.append(postItem)
                        
                    }
                    
                    
                }
                
                self.tableView.reloadData()
                
            } else {
                
                print("\(error?.localizedDescription)")
                
            }
            
            
            
        }
        
    }
    
    private func createNewButton(){
        
        newButton = ActionButton(attachedToView: self.view, items: [])
        newButton.action = { button in
            print ("Post Button Pressed")
            self.performSegueWithIdentifier("New Post Composer", sender: self)
            
        }
        
        newButton.backgroundColor = UIColor.greenColor()
        
        
    }
    
    
    //データをページ移動の際に一緒に移動させる
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier ==  "Show Comment Page"{
            
            let commentViewController = segue.destinationViewController as! CommentViewController
            
            commentViewController.post = sender as! Post
        
        }
    
    }


}




extension ViewController: UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
        
        cell.post = posts[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
    
    
    
}

extension ViewController: PostTableViewCellDelegate{
    
    func commentButton_Clicked(post: Post) {
       
        self.performSegueWithIdentifier("Show Comment Page", sender: post)
        
    }
    
}



//ログイン画面のバックをやるよpresentLoginViewController
extension ViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    func presentLoginViewController() {
        
        let loginContoroller = PFLogInViewController()
        let signUpController = PFSignUpViewController()
        
        
        loginContoroller.delegate = self
        signUpController.delegate = self
        
        loginContoroller.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton]
    
        loginContoroller.signUpController = signUpController
        
        presentViewController(loginContoroller, animated: true, completion: nil)
    }
    
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        //トップ画面へ
        logInController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    

}




