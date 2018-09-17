//
//  Global.swift
//  Maskat
//
//  Created by YoshiakiKishi on 2016/01/27.
//  Copyright © 2016年 Yoshua Dilham Kishi. All rights reserved.
//

import Parse
import UIKit


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


