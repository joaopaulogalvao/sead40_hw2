//
//  GalleryViewController.swift
//  sead40_hw2
//
//  Created by Joao Paulo Galvao Alves on 8/13/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: UIViewController {

  @IBOutlet weak var collectionViewGallery: UICollectionView!
  
  
  var fetchResult : PHFetchResult!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      collectionViewGallery.delegate = self
      collectionViewGallery.dataSource = self
      
      fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
      
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

extension GalleryViewController :  UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fetchResult.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionViewGallery.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! CollectionViewCell
    if let asset = fetchResult[indexPath.row] as? PHAsset {
             PHCachingImageManager.defaultManager().requestImageForAsset(<#asset: PHAsset!#>, targetSize: <#CGSize#>, contentMode: <#PHImageContentMode#>, options: <#PHImageRequestOptions!#>, resultHandler: <#((UIImage!, [NSObject : AnyObject]!) -> Void)!##(UIImage!, [NSObject : AnyObject]!) -> Void#>)
    }
    
  }
  
}

extension GalleryViewController : UICollectionViewDelegate {
  
}

