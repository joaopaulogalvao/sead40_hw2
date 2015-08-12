//
//  TimeLineViewController.swift
//  sead40_hw2
//
//  Created by Joao Paulo Galvao Alves on 8/12/15.
//  Copyright (c) 2015 jalvestech. All rights reserved.
//

import UIKit
import Parse

class TimeLineViewController: UIViewController, UITableViewDataSource {

  @IBOutlet weak var tableViewTimeLine: UITableView!
  
  let postsArray = []
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let query = PFQuery(className: "Post")
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
      } else if let posts = results as? [PFObject] {
        println(posts.count)
      }
    }
    
    self.tableViewTimeLine.dataSource = self
    // Do any additional setup after loading the view.
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

extension TimeLineViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.postsArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let timeLineCell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as! TimeLineCell
    
    var postsFromUser = self.postsArray[indexPath.row]
    
    if let postImage = self.postImage {
      
      timeLineCell.imgViewPostPhoto.setBackgroundImage(postImage, forState: UIControlState.Normal)
      
      
    } else {
      
    }
    
    return timeLineCell

  }
  
  
  
}
