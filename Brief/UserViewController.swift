//
//  UserViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cameraImage: UIImageView!
    
    var cloudManager = BriefCloudManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userProfileView.clipsToBounds = true;
        
        self.userProfileView.layer.borderWidth = 2.0;
        self.userProfileView.layer.cornerRadius = 10
        self.userProfileView.layer.borderColor = UIColor.blackColor().CGColor
        
        // this will appear as the title in the navigation bar
        var label = UILabel()
        label.text = "me"
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(25.0)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label;
        label.sizeToFit()
        
        self.userName.text = user.getFirstName() + " " + user.getLastName()
        self.profileImageView.image = user.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    @IBAction func changePicture(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        
        self.presentViewController(imagePicker, animated: true, nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            // Get picked image from info dictionary
            var image = info[UIImagePickerControllerOriginalImage] as UIImage
            
            var newSize = CGSizeMake(512, 512);
            
            if (image.size.width > image.size.height) {
                newSize.height = round(newSize.width * image.size.height / image.size.width);
            } else {
                newSize.width = round(newSize.height * image.size.width / image.size.height);
            }
            
            UIGraphicsBeginImageContext(newSize)
            image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            var data = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())
            UIGraphicsEndImageContext();

            // write the image out to a cache file
            var cachesDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true, error: nil)
            var temporaryName = NSUUID.UUID().UUIDString + ".png"
            if let localURL = cachesDirectory?.URLByAppendingPathComponent(temporaryName) {
                data.writeToURL(localURL, atomically: true)
                self.cloudManager.uploadAssetWithURL(localURL, completionHandler: { record in
                    
                })
            }
        
            // Put that image onto the screen in our image view
            self.profileImageView.image = image
        
            
            // dismiss the modal
            self.dismissViewControllerAnimated(true, completion: nil)

            
      //  })

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // dismiss the modal
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
