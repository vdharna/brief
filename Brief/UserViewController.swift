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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.


    }
    
    @IBAction func changePicture(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: {})
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // Get picked image from info dictionary
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        // Put that image onto the screen in our image view
        self.profileImageView.image = image
        
        // dismiss the modal
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


}
