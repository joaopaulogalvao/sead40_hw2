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
  
  @IBOutlet weak var collectionViewFilters: UICollectionView!
  
  
  //MARK: Constraint Enter Filter Buffer Constants
  let kleadingImageViewConstraint : CGFloat = 40
  let KtrailingImageViewConstraintBuffer : CGFloat = -40
  let ktopImageViewConstraint : CGFloat = 40
  let kbottomImageViewConstraint : CGFloat = 70
  let kbottomCollectionViewConstraint :CGFloat = 8
  
  //MARK: Constraint Close Filter Buffer Constants
  let kcloseFilterLeadingImageViewConstraint : CGFloat = -40
  let kcloseFilterTrailingImageViewConstraint : CGFloat = 40
  let kcloseFilterTopImageViewConstraint : CGFloat = -40
  let kcloseFilterBottomImageViewConstraint : CGFloat = 70
  let kcloseFilterBottomCollectionViewConstraint : CGFloat = -100
  
  
  //MARK: Outlets
  @IBOutlet weak var btnAlert: UIButton!
  @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var leadingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomCollectionViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!
  
  let picker : UIImagePickerController = UIImagePickerController()
  
  //MARK: Alert Controllers
  let alert = UIAlertController(title: "Button Clicked", message: "Yes the button was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let cameraPhotoAlert = UIAlertController(title: "Camera/Photo", message: "Button clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let filtersAlert = UIAlertController(title: "Filters", message: "Filters Clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set picker delegate
    self.picker.delegate = self
    //self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    
    // Set picker dataSource
    collectionViewFilters.dataSource = self
    
    if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
      
    }
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
      println("Alert cancelled")
    }
    
    // Create Camera Alert Action
    let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
      
      // Check if a camera is available
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        
        // Present the camera
        self.picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(self.picker, animated: true, completion: { () -> Void in
          //Enter completion here
        })
      } else {
        
        // Alert that there is not a camera available
        let alertNoCamera = UIAlertView(title: "Alert", message: "No camera available!", delegate: self, cancelButtonTitle: "Ok")
        
        // Show alert
        alertNoCamera.show()
        
        // Show Photo Library
        self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(self.picker, animated: true, completion: nil)
      }
      
    })
    
    // Create Photo Library Alert Action
    let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
      self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      self.presentViewController(self.picker, animated: true, completion: nil)
    })
    
    //Show camera action
    self.cameraPhotoAlert.addAction(camera)
    
    //Show photoLibrary action
    self.cameraPhotoAlert.addAction(photoLibrary)
    
    //Show cancelAction
    self.cameraPhotoAlert.addAction(cancelAction)
    
    // Create Choose Image Alert
    let chooseImage = UIAlertAction(title: "Choose Image", style: UIAlertActionStyle.Default) { (alert) -> Void in
      
      self.presentViewController(self.cameraPhotoAlert, animated: true, completion: nil)
  
      println("Choose image selected")
      
    }
    
    // Show choose image alert
    alert.addAction(chooseImage)
    
    // Check if it is an iPhone
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      
      let filterAction = UIAlertAction(title: "Choose Filter", style: UIAlertActionStyle.Default) { (alert) -> Void in
        self.enterFilterMode()
      }
      
      // Show filter action
      alert.addAction(filterAction)
    }
    
    //Create uploadAction
    let uploadAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.Default) { (alert) -> Void in
      
      self.uploadToParse()
    }
    
    // Show upload action
    alert.addAction(uploadAction)
    
    // Show Cancel Action
    alert.addAction(cancelAction)
    
    
    /*
    
    ----------------------------------------------------------
    Alert Action style
    ----------------------------------------------------------
    // Use alert if needed
    
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
    */
    
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
    leadingImageViewConstraint.constant = kleadingImageViewConstraint
    trailingImageViewConstraint.constant = KtrailingImageViewConstraintBuffer
    topImageViewConstraint.constant = ktopImageViewConstraint
    bottomImageViewConstraint.constant = kbottomImageViewConstraint
    bottomCollectionViewConstraint.constant = kbottomCollectionViewConstraint
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func closeFilterMode (){
    
    println("Close Filter pressed")
    
    leadingImageViewConstraint.constant = kcloseFilterLeadingImageViewConstraint
    trailingImageViewConstraint.constant = kcloseFilterTrailingImageViewConstraint
    topImageViewConstraint.constant = kcloseFilterTopImageViewConstraint
    bottomImageViewConstraint.constant = kcloseFilterBottomImageViewConstraint
    bottomCollectionViewConstraint.constant = kcloseFilterBottomCollectionViewConstraint
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    self.navigationItem.rightBarButtonItem = nil
  }
  
  func uploadToParse () {
    
    let post = PFObject(className: "Post")
    post["text"] = "photo1"
    
    if let image = self.imageView.image, data = UIImageJPEGRepresentation(image, 1.0)
    {
      
      let file = PFFile(name: "post.jpeg", data: data)
      post["image"] = file
      
    }
    
    post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
      
    })
    
  }
  
}
  // MARK: - UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! UICollectionViewCell
      cell.backgroundColor = UIColor.redColor()
    
    return cell
  }
}

  // MARK: - UIImagePickerControllerDelegate
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


















