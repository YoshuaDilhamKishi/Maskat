//
//  PostViewController.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/25.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import UIKit
import Photos
import Parse

class PostViewController: UIViewController {
    
    
    @IBOutlet weak var navaigationBar: UINavigationBar!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: DesignableImageView!
    
    
    

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    private var PostImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navaigationBar.tintColor = UIColor.whiteColor()
        navaigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navaigationBar.barTintColor = UIColor(hex: "#90d52e")
        
        
        //画像を丸める
        userProfileImage.layer.cornerRadius = userProfileImage.layer.bounds.width/2
        userProfileImage.clipsToBounds = true
        
        usernameLabel.text! = User.currentUser()!.username!
        
        
        
        //テキストの編集
        
        postText.text = ""
        postText.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
      
        //Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func keyboardWillHide(notification: NSNotification){
        
        self.postText.contentInset = UIEdgeInsetsZero
        self.postText.scrollIndicatorInsets = UIEdgeInsetsZero
        
        
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = ( userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        
        self.postText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+10, right: 0)
        self.postText.scrollIndicatorInsets = self.postText.contentInset
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func backButton_Clicked(sender: AnyObject) {
        
        postText.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func postButton_Clicked(sender: AnyObject) {
        
        
        //条件をしていくよ
        if postImage == nil {
            shakeImageView()
        
        
        } else if postText.text.isEmpty{
            
            //ここに入れるのは
        
        
        } else {
        
        
        createNewPost()
    
        
        postText.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    }

    func createNewPost() {
        
        let newPost = Post(user: User.currentUser()!, postImage: PostImage, postText: postText.text, numberOfLikes: 0)

        newPost.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if error == nil{
                
                print("post saved")
                
                
                // local notification 
                
                let center = NSNotificationCenter.defaultCenter()
                let notification = NSNotification(name: "NewPostCreated", object: nil, userInfo: ["newPostObject" : newPost])
                center.postNotification(notification)
            
            }else{
                
                print("\(error?.localizedDescription)")
            
            }
            
        }
        
        
    }
    
    
    //画像を縮小していくよ
    struct ImageSize {
        
        static let height: CGFloat = 480
    }
    
    func createFileForm(image: UIImage) -> PFFile! {
     
        let ratio = image.size.width / image.size.height
        let resizedImage = resizeImage(image, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
        
        return PFFile(name: "image.jpg", data: imageData)
        
        
    }
    
    func resizeImage(originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage {
        
        let newSize = CGSizeMake(width, height)
        let newRectangle = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(newSize)
        
        originalImage.drawInRect(newRectangle)
        
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
        
        
    }
    
    
    func shakeImageView() {
        
        postImage.animation = "shake"
        postImage.curve = "speing"
        postImage.duration = 1.0
        postImage.animate()
        
    }

}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBAction func PicFeaturedImage(sender: AnyObject) {
        
        
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_barrier_async(dispatch_get_main_queue(), { () -> Void in
                    self.PicFeaturedImage(sender)
                })
            })
            return
            
        }
        
        if authorization == .Authorized {
            
            let controller = ImagePickerSheetController()
            controller.addAction(ImageAction(title: NSLocalizedString("Take a Photo or Video!", comment: "ActionTitle"),secondaryTitle: NSLocalizedString("Use this one!", comment: "ActionTitle"), handler: { (_) -> () in
                self.presentCamera()
                
                }, secondaryHandler: { (action, numberOfPhoto) -> ()in
                    
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.PostImage = images[0]
                        self.postImage.image = self.PostImage
                    })
                    
                    
            }))
            
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "ActionTitle"), style: .Cancel, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
            
            
                  }
        
        
        
    }
    
    
    
    func presentCamera(){
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.postImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}




    
    




