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
        
        if let preferredName = user.getPreferredName() {
            self.userName.text = preferredName
        } else {
            self.userName.text = user.getFirstName() + " " + user.getLastName()
        }
        
        self.profileImageView.image = user.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    @IBAction func changePicture(sender: AnyObject) {
        
        var imagePicker = UIImagePickerController()
        var sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType


        var profileImageActionOptions = UIAlertController(title: "Edit Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // cancel
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        profileImageActionOptions.addAction(cancelAction)
        
        // take photo
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var takePhotoAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { alertAction in
                sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.sourceType = sourceType
                self.presentViewController(imagePicker, animated: true, nil)
            })
            
            profileImageActionOptions.addAction(takePhotoAction)
            
        }
        
        // choose photo
        var choosePhotoAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default, handler: { alertAction in
            self.presentViewController(imagePicker, animated: true, nil)
        })
        profileImageActionOptions.addAction(choosePhotoAction)

        // delete photo
        var deletePhotoAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.Destructive, handler: { alertAction in
            user.deleteProfilePhoto()
            self.profileImageView.image = nil
        })
        profileImageActionOptions.addAction(deletePhotoAction)
        
        self.presentViewController(profileImageActionOptions, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // Get picked image from info dictionary
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        var newSize = CGSizeMake(256, 256);
        
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

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // dismiss the modal
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
