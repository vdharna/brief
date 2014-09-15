//
//  UserViewController.swift
//  Brief
//
//  Created by Dharminder Dharna on 9/8/14.
//  Copyright (c) 2014 Simple Enterprises. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    var cloudManager = BriefCloudManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userProfileView.clipsToBounds = true;
        var radius = self.userProfileView.bounds.width / 2.0
        self.userProfileView.layer.borderWidth = 2.0;
        self.userProfileView.layer.cornerRadius = radius
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
        
        self.table.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let name = user.preferredName {
            self.userName.text = user.preferredName
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
        
        //update the photo for the user
        user.updateProfileImage(image)
        // Put that image onto the screen in our image view
        self.profileImageView.image = user.image
        
        // dismiss the modal
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // dismiss the modal
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: --------------------------------
    // MARK: UITableViewDatasource methods
    // MARK: --------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.table.dequeueReusableCellWithIdentifier("UITableViewCell") as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var text = ""
        
        switch (indexPath.section) {
        case 0:
            text = "Changed Preferred Display Name"
        case 1:
            switch (indexPath.row) {
            case 0:
                text = "My Brief Recipients"
            case 1:
                text = "Contacts Sending Me Briefs"
            default:
                text = ""
            }
        case 2:
            text = "Manage My Subscriptions"
        default:
            text = ""
        }
    
        cell.textLabel?.text = text
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch (section) {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Personal Info"
        case 1:
            return "Team Settings"
        case 2:
            return "Subscription Settings"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath)
        
        switch(indexPath.section) {
        
        case 0:
            // throw up a modal for changing name
            showChangeNameModal()
            
        case 1:
            switch (indexPath.row) {
            case 0:
                // throw up modal for adding team members for Brief escalation
                println("throw up modal for adding team members for Brief escalation")
                showTeamMembers()
            case 1:
                // throw up modal for adding team members for Brief reception
                println("throw up modal for adding team members for Brief reception")

            default:
                println("No screen to show")
            }
        case 2:
            // throw up modal for subscriptions
            println("throw up modal for subscriptions")
        default:
            println("No screen to show")
        }
    }
    
    func showChangeNameModal() {
        let mvc = ChangePreferredNameViewController(nibName: "ChangePreferredNameViewController", bundle: NSBundle.mainBundle())
        
        let nc = UINavigationController(rootViewController: mvc)
        
        nc.navigationBar.barTintColor = UIColor.blackColor()
        nc.navigationBar.tintColor = UIColor.whiteColor()
        nc.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.presentViewController(nc, animated: true, completion: nil)
    }
    
    func showTeamMembers() {
        
        let mvc = VisibleTeamMembersViewController(nibName: "VisibleTeamMembersViewController", bundle: NSBundle.mainBundle())
        
        let nc = UINavigationController(rootViewController: mvc)
        
        nc.navigationBar.barTintColor = UIColor.blackColor()
        nc.navigationBar.tintColor = UIColor.whiteColor()
        nc.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.presentViewController(nc, animated: true, completion: nil)
        
    }


}
