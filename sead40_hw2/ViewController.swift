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
  @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var leadingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomCollectionViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!
  
  let picker : UIImagePickerController = UIImagePickerController()
  
  let alert = UIAlertController(title: "Button Clicked", message: "Yes the button was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let cameraPhotoAlert = UIAlertController(title: "Camera/Photo", message: "Button clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
      
    }
    
  
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
      println("Alert cancelled")
    }
    
    let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        
        self.picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(self.picker, animated: true, completion: { () -> Void in
          //Enter completion here
        })
      } else {
        
        let alertNoCamera = UIAlertView(title: "Alert", message: "No camera available!", delegate: self, cancelButtonTitle: "Ok")
        alertNoCamera.show()
        self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(self.picker, animated: true, completion: nil)
      }
      
    })
    
    let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
      self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      self.presentViewController(self.picker, animated: true, completion: nil)
    })
    
    self.cameraPhotoAlert.addAction(camera)
    self.cameraPhotoAlert.addAction(photoLibrary)
    self.cameraPhotoAlert.addAction(cancelAction)
    
    let chooseImage = UIAlertAction(title: "Choose Image", style: UIAlertActionStyle.Default) { (alert) -> Void in
      
      self.presentViewController(self.cameraPhotoAlert, animated: true, completion: nil)
  
      println("Choose image selected")
      
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
    
    let uploadAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.Default) { (alert) -> Void in
      let post = PFObject(className: "Post")
      post["text"] = "bla bla bla"
      
      if let image = self.imageView.image, data = UIImageJPEGRepresentation(image, 1.0)
      {
        
        let file = PFFile(name: "post.jpeg", data: data)
        post["image"] = file
        
      }
      
      post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
        
      })
      
    }
    
    alert.addAction(cancelAction)
    alert.addAction(chooseImage)
    alert.addAction(filter1)
    alert.addAction(filter2)
    alert.addAction(filter3)
    alert.addAction(uploadAction)
    
  
    self.picker.delegate = self
    //self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - My Actions
  
  @IBAction func showAction(sender: AnyObject) {
    
    alert.modalPresentationStyle = UIModalPresentationStyle.PageSheet
    
    
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = btnAlert.frame
    }
    self.presentViewController(alert, animated: true, completion: nil)
    
    
  }
  
  func enterFilterMode () {
    leadingImageViewConstraint.constant = 40
    trailingImageViewConstraint.constant = -40
    topImageViewConstraint.constant = 40
    bottomImageViewConstraint.constant = 70
    bottomCollectionViewConstraint.constant = 8
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
  
  
  // MARK: - UIImagePickerDelegate
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    self.imageView.image = image
    self.picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion: nil)
    println("Picker Cancelled")
  }
  
  // MARK: - UIActionSheetDelegate
  func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
    switch buttonIndex{
      
    case 0:
      println("selected camera")
      self.presentViewController(self.picker, animated: true, completion: nil)
      break
    default:
      println("selected")
      break
    }
  }
  
  
}


















