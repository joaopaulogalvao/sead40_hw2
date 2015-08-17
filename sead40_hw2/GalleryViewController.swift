//
//  GalleryViewController.swift
//  sead40_hw2
//
//  Created by Joao Paulo Galvao Alves on 8/13/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit
import Photos

protocol ImageSelectedDelegate : class {
  func controllerDidSelectImage(UIImage) -> (Void)
}


class GalleryViewController: UIViewController {

  @IBOutlet weak var collectionViewGallery: UICollectionView!
  
  //Set our own delegate property to notify who we want to be the delegate
  weak var delegate : ImageSelectedDelegate?
  
  // MARK: - Size properties
  var fetchResult : PHFetchResult!
  var assetCollection : PHAssetCollection!
  let cellSize = CGSize(width: 100, height: 100)
  var finalImage : CGSize!
  var startingScale : CGFloat = 0
  var scale : CGFloat = 0
  var albumFound : Bool = false
  let albumName = "Parse Photos"
  
  // MARK: - Constants
  let kTestCGSize = CGSize(width: 50, height: 50)

  // MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      collectionViewGallery.delegate = self
      collectionViewGallery.dataSource = self
      
      
      let options = PHFetchOptions()
      
      options.predicate = NSPredicate(format:"title like %@",albumName)
      
      fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
      
      // Predicate key Title is only accepted with PHAssetCollection - attention to that
      let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: options)
      
      if (collection.firstObject != nil) {
        self.albumFound = true
        self.assetCollection = collection.firstObject as! PHAssetCollection
      } else {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
          let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(self.albumName)
        }, completionHandler: { (success, error) -> Void in
          println("success")
          self.albumFound = {success ? true:false}()
        })
      }
      
      
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchRecognized:")
      collectionViewGallery.addGestureRecognizer(pinchGesture)
      
    }
  
  
  // MARK: - My Actions
  func pinchRecognized(pinch : UIPinchGestureRecognizer) {
    
    if pinch.state == UIGestureRecognizerState.Began {
      println("began!")
      startingScale = pinch.scale
    }
    
    if pinch.state == UIGestureRecognizerState.Changed {
      println("changed!")
    }
    
    if pinch.state == UIGestureRecognizerState.Ended {
      println("ended!")
      scale = startingScale * pinch.scale
      let layout = collectionViewGallery.collectionViewLayout as! UICollectionViewFlowLayout
      let newSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
      
      collectionViewGallery.performBatchUpdates({ () -> Void in
        layout.itemSize = newSize
        layout.invalidateLayout()
        }, completion: nil )
      
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

  // MARK: - UICollectionViewDataSource
extension GalleryViewController :  UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fetchResult.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionViewGallery.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! CollectionViewCell
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: cellSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info) -> Void in
        if let image = image {
          println("calling request handler for row :\(indexPath.row) for image size: \(image.size)")
          cell.imgViewCollectionCell.image = image
        }
      })
    }
    return cell
  }
  
}

  //MARK: - UICollectionViewDelegate
extension GalleryViewController : UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    // Delegation order - Pyramid -> UIViewController -> Gallery -> collectionView
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: finalImage, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image , info) -> Void in
        if let image = image {
          
          //Gallery view controller gets the image from UICollectionView and send to UIViewController 
          self.delegate?.controllerDidSelectImage(image)
          
          println("Gallery Cell selected \(indexPath.row)")
          self.navigationController?.popViewControllerAnimated(true)
        }
      })
    }
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
      let request = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.fetchResult)
    }, completionHandler: { (success, error) -> Void in
      println("Success")
    })
    
  }
  
}

