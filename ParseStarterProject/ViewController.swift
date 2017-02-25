/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse


class ViewController: UIViewController {
    //class variable
    var newUser = false
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpProcess(_ sender: Any) {
        //add user
        let user  = PFUser()
        if username.text != "" && password.text != ""{
            if signupButton.titleLabel?.text == "Sign Up"{
                print("Sign Up")
                user.username = username.text
                user.password = password.text
                user.signUpInBackground(block: { (saved, error) in
                    if error != nil{
                        if let error  = error{
                            let errorMessage = error.localizedDescription
                            print(errorMessage)
                            if errorMessage.contains("already exists"){
                                let alert = UIAlertController(title: "Opps", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (alerted) in
                                    alert.dismiss(animated: true, completion: nil)
                                    }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else{
                                let alert = UIAlertController(title: "Opps", message: "Something weird happened. Try sigining up in sometime", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (alerted) in
                                    alert.dismiss(animated: true, completion: nil)
                                    }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            self.username.text = ""
                            self.password.text = ""
                        }
                    }
                    else{
                        print("Successfull sign up")
                        //notify the user
                        let alert = UIAlertController(title: "Success", message: "Thanks for signing up", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alterted) in
                            self.performSegue(withIdentifier: "toProfileUpdate", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.username.text = ""
                        self.password.text = ""
                    }
                })
            }
            else{
                print("Login")
                //verfiy user
                PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: { (loggedIn, error) in
                    if error != nil{
                        print(error!.localizedDescription)
                        //notify the user
                        let alert = UIAlertController(title: "Opps", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (okPressed) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.username.text = ""
                        self.password.text = ""
                    }
                    else if let loggedInUser = loggedIn{
                        print(loggedInUser)
                        //notify the user
                        print("User logged in")
                        self.performSegue(withIdentifier: "toProfileUpdate", sender: self)
                    }
                })
            }
        }
        else{
            //notify the user
            let alert = UIAlertController(title: "Opps", message: "Invalid username/password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (okPressed) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            self.username.text = ""
            self.password.text = ""
        }
    }
    
    @IBAction func loginProcess(_ sender: Any) {
        if newUser == false{
            loginButton.setTitle("Sign Up", for: .normal)
            signupButton.setTitle("Login", for: .normal)
            newUser = true
        }
        else{
            loginButton.setTitle("Login", for: .normal)
            signupButton.setTitle("Sign Up", for: .normal)
            newUser = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //before segue get the image:
        if segue.identifier == "toProfileUpdate"{
            let query = PFUser.current()
            if let imageFile = query?.object(forKey: "profileImage") as? PFFile{
                imageFile.getDataInBackground(block: { (imagedata, error) in
                    if error != nil{
                        print("Error \(error)")
                    }
                    else{
                        if let profileImageData = imagedata{
                            if let profileImage = UIImage(data: profileImageData){
                                let destinationViewController = segue.destination as! ProfileUpdateController
                                //set retrived image
                                destinationViewController.profilePicture = profileImage
                                print("set retrived image")
                                destinationViewController.updateProfileButtontTitle = "Update profile picture"
                            }
                        }
                    }
                })
            }
            else{
                let destinationViewController = segue.destination as! ProfileUpdateController
                //set retrived image
                destinationViewController.profilePicture = UIImage(named: "addPerson.jpg")!
                print("set backup image")
                destinationViewController.updateProfileButtontTitle = "Set a profile picture"
                
            }
        }
    }
}
