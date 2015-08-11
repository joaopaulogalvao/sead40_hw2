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
      self.presentViewController(self.picker, animated: true, completion: nil)
      println("Camera selected")
    }
    
    let filter1 = UIAlertAction(title: "Filter1", style: UIAlertActionStyle.Default) { (alert) -> Void in
      println("Filter 1 selected")
    }
    
    let filter2 = UIAlertAction(title: "Filter2", style: UIAlertActionStyle.Default) { (alert) -> Void in
      println("Filter 2 selected")
    }
    
    alert.addAction(cancelAction)
    alert.addAction(camera)
    alert.addAction(filter1)
    alert.addAction(filter2)
    
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

