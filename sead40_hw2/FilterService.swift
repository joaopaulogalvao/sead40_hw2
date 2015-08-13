//
//  FilterService.swift
//  sead40_hw2
//
//  Created by Joao Paulo Galvao Alves on 8/12/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import Foundation
import UIKit

class FilterService {
  // Class function - no properties
  class func ciPhotoEffectMono(original : UIImage, context : CIContext) -> UIImage! {
    
    
    let image = CIImage(image: original)
    let filter = CIFilter(name: "CIPhotoEffectMono")
    filter.setValue(image, forKey: kCIInputImageKey)
    
    return filteredImageFromFilter(filter, context: context)
    
  }
  
  class func ciPhotoEffectTransfer(original : UIImage, context : CIContext) -> UIImage!{
    
    let image = CIImage(image: original)
    let filter = CIFilter(name: "CIPhotoEffectTransfer")
    filter.setValue(image, forKey: kCIInputImageKey)
    
    return filteredImageFromFilter(filter, context: context)
  }
  
  class func ciBumDistortion(original : UIImage, context : CIContext) -> UIImage!{
    
    let image = CIImage(image: original)
    let filter = CIFilter(name: "CIBumpDistortion")
    filter.setValue(image, forKey: kCIInputImageKey)
    
    return filteredImageFromFilter(filter, context: context)
  }
  
  
  
  
  
  private class func filteredImageFromFilter(filter  : CIFilter, context : CIContext) -> UIImage! {
    
    let outputImage = filter.outputImage
    let extent = outputImage.extent()
    let cgImage = context.createCGImage(outputImage, fromRect: extent)
    return UIImage(CGImage: cgImage)!
    
  }
}