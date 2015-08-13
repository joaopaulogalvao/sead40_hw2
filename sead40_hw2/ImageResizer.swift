//
//  ImageResizer.swift
//  sead40_hw2
//
//  Created by Joao Paulo Galvao Alves on 8/13/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import Foundation
import UIKit

class ImageResizer {
  
  class func resizeImage(image : UIImage, size : CGSize) -> UIImage {
    
    UIGraphicsBeginImageContext(size)
    
    image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return resizedImage
  }
}

