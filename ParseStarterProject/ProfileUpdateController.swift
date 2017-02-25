//
//  ProfileUpdateController.swift
//  ParseStarterProject-Swift
//
//  Created by Viraj Padte on 2/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileUpdateController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //UI reference
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userGender: UISwitch!
    @IBOutlet weak var interestedGender: UISwitch!
    @IBOutlet weak var updateProfileButton: UIButton!
    
    //class variables:
    
    var updateProfileButtontTitle = ""
    var profilePicture = UIImage()
    
    
    //class controllers

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi new ")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = profilePicture
        updateProfileButton.setTitle(updateProfileButtontTitle, for: UIControlState.normal)
    }
    @IBAction func updateProfileImage(_ sender: Any) {
        print("pickImage")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profilePicture = pickedImage
            imageView.image = profilePicture
            self.dismiss(animated: true, completion: nil)
        }
        else{
            print("couldnt get image")
        }
    }
    @IBAction func updateUserProfile(_ sender: Any) {
        if let currentUser = PFUser.current(){
            if userGender.isOn{
                print("user is a female")
                currentUser.setValue(0, forKey: "Gender")
            }
            else{
                print("male user")
                currentUser.setValue(1, forKey: "Gender")
            }
            if interestedGender.isOn{
                print("user into females")
                currentUser.setValue(0, forKey: "interestedGender")
            }
            else{
                print("user into males")
                currentUser.setValue(1, forKey: "interestedGender")
            }
            if let profileImage = imageView.image{
                if let imageData = UIImageJPEGRepresentation(profileImage, 0.3){
                    if let imageFile = PFFile(name: (PFUser.current()?.username)?.appending(".jpg"), data: imageData){
                        currentUser.setObject(imageFile, forKey: "profileImage")
                        print("set file")
                        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                        loading.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                        loading.center = self.view.center
                        loading.hidesWhenStopped = true
                        loading.startAnimating()
                        self.view.addSubview(loading)
                        self.view.isUserInteractionEnabled = false
                        currentUser.saveInBackground { (updated, error) in
                            if error != nil{
                                print("Error\(error)")
                                //notify
                                let alert = UIAlertController(title: "Opps", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (okPressed) in
                                    alert.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if updated{
                                loading.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("Updated")
                                //notify
                                let alert = UIAlertController(title: "Success", message: "Your profile is updated", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (okPressed) in
                                    alert.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
