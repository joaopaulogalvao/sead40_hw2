//
//  ViewController.swift
//  sead40_hw2
//
//  Created by Joao Paulo Galvao Alves on 8/10/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var btnAlert: UIButton!
  
  let picker : UIImagePickerController = UIImagePickerController()
  
  let alert = UIAlertController(title: "Button Clicked", message: "Yes the button was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let testObject = PFObject(className: "TestObject")
    testObject["foo"] = "bar"
    testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
      println("Object has been saved.")
    }
    
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
      
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
      println("Alert cancelled")
    }
    
    let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (alert) -> Void in
      
      if UIImagePickerController.isSourceTypeAvailable(
        UIImagePickerControllerSourceType.Camera) {
          self.picker.sourceType = UIImagePickerControllerSourceType.Camera
          // Code here
          self.presentViewController(self.picker, animated: true, completion: nil)
      } else {
          self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(self.picker, animated: true, completion: nil)
        println("buy a decent iPhone!!!")
      }
      
      
      println("Camera selected")
    }
    
    let filter1 = UIAlertAction(title: "Black & White", style: UIAlertActionStyle.Default) { (alert) -> Void in
      println("Mono/Black & White selected")
      
      
      // Optional binding to prevent the user from filtering when there is no image
      if let image = self.imageView.image {
        
        let image = CIImage(image: self.imageView.image!)
        let monoEffect = CIFilter(name: "CIPhotoEffectMono")
        monoEffect.setValue(image, forKey: kCIInputImageKey)
        
        //cpu context, not as fast as GPU context
        let context = CIContext(options: nil)
        
        //gpu context
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        
        let outputImage = monoEffect.outputImage
        let extent = outputImage.extent()
        let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
        let finalImage = UIImage(CGImage: cgImage)
        self.imageView.image = finalImage
        
      }
      
      
    }
    
    let filter2 = UIAlertAction(title: "Vintage", style: UIAlertActionStyle.Default) { (alert) -> Void in
      println("Photo Effect Transfer selected")
      
      // Option Binding to prevent the user from filtering when there is no image
      if let image = self.imageView.image {
        
        let image = CIImage(image: self.imageView.image!)
        let photoEffectTransfer = CIFilter(name: "CIPhotoEffectTransfer")
        photoEffectTransfer.setValue(image, forKey: kCIInputImageKey)
        
        //cpu context, not as fast as GPU context
        let context = CIContext(options: nil)
        
        //gpu context
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        
        let outputImage = photoEffectTransfer.outputImage
        let extent = outputImage.extent()
        let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
        let finalImage = UIImage(CGImage: cgImage)
        self.imageView.image = finalImage
        
      }
    }
    
    let filter3 = UIAlertAction(title: "Distortion", style: UIAlertActionStyle.Default) { (alert) -> Void in
      // Option Binding to prevent the user from filtering when there is no image
      if let image = self.imageView.image {
        
        let image = CIImage(image: self.imageView.image!)
        let distortion = CIFilter(name: "CIBumpDistortion", withInputParameters: ["inputRadius": 350])
        distortion.setValue(image, forKey: kCIInputImageKey)
        
        //cpu context, not as fast as GPU context
        let context = CIContext(options: nil)
        
        //gpu context
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        
        let outputImage = distortion.outputImage
        let extent = outputImage.extent()
        let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
        let finalImage = UIImage(CGImage: cgImage)
        self.imageView.image = finalImage
        
      }
    }
    
    alert.addAction(cancelAction)
    alert.addAction(camera)
    alert.addAction(filter1)
    alert.addAction(filter2)
    alert.addAction(filter3)
    
    self.picker.delegate = self
    self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func showAction(sender: AnyObject) {
    
    alert.modalPresentationStyle = UIModalPresentationStyle.PageSheet
    
    
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = btnAlert.frame
    }
    self.presentViewController(alert, animated: true, completion: nil)
    
  }
  
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    self.imageView.image = image
    self.picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion: nil)
    println("Picker Cancelled")
  }
  
}

