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
        
        /*
        //sample data automation script
        //images of 12 women and 12 men - sample test data
        let imageAddressList = ["https://static.pexels.com/photos/27411/pexels-photo-27411.jpg", "https://static.pexels.com/photos/38554/girl-people-landscape-sun-38554.jpeg", "https://static.pexels.com/photos/206559/pexels-photo-206559.jpeg", "https://static.pexels.com/photos/295821/pexels-photo-295821.jpeg", "https://static.pexels.com/photos/58020/pexels-photo-58020.jpeg", "https://static.pexels.com/photos/24156/pexels-photo-24156.jpg", "https://static.pexels.com/photos/157907/smile-color-laugh-black-157907.jpeg", "https://static.pexels.com/photos/192555/pexels-photo-192555.jpeg", "https://static.pexels.com/photos/227335/pexels-photo-227335.jpeg", "https://static.pexels.com/photos/26180/pexels-photo-26180.jpg", "https://static.pexels.com/photos/211997/pexels-photo-211997.jpeg", "https://static.pexels.com/photos/63953/pexels-photo-63953.jpeg", "https://static.pexels.com/photos/91227/pexels-photo-91227.jpeg", "https://static.pexels.com/photos/251829/pexels-photo-251829.jpeg", "https://static.pexels.com/photos/52648/pexels-photo-52648.jpeg", "https://static.pexels.com/photos/24257/pexels-photo-24257.jpg", "https://static.pexels.com/photos/24272/pexels-photo-24272.jpg", "https://static.pexels.com/photos/211050/pexels-photo-211050.jpeg","https://static.pexels.com/photos/21278/pexels-photo.jpg", "https://static.pexels.com/photos/108048/pexels-photo-108048.jpeg", "https://static.pexels.com/photos/25733/pexels-photo.jpg", "https://static.pexels.com/photos/31330/pexels-photo-31330.jpg", "https://static.pexels.com/photos/185847/pexels-photo-185847.jpeg", "https://static.pexels.com/photos/11392/pexels-photo-11392.jpeg"]
        
        let usernames =
        ["Jane", "Jonna", "Kendra", "Kenna", "Pretty", "Timmy", "Jade", "Molly", "Natasha", "Kelly", "Alicia", "Fionna","George", "Mark", "Coddy", "Johnson", "Peter", "Chris", "John", "Leo", "Travis", "Nathan", "Donald", "Tyler"]
        
        let genders = [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1]
        
        let interestedGenders = [1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0]
    
        for (index, address) in imageAddressList.enumerated(){
            let url = URL(string: address)
            do{
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                let imageData = UIImageJPEGRepresentation(image!, 0.2)
                let imageFile = PFFile(name: "\(usernames[index]).jpg", data: imageData!)
                let user = PFUser()
                user.username = usernames[index]
                user.password = "password"
                user["profileImage"] = imageFile
                user["gender"] = genders[index]
                user["interestedGender"] = interestedGenders[index]
                user.signUpInBackground(block: { (signedUp, error) in
                    if error != nil{
                        print(error)
                    }
                    else if signedUp{
                        print("signed up")
                    }
                })
                
            }
            catch{
                print("cant download")
            }
        }
        */
 
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
                        //print(loggedInUser)
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
        print("before segue")
        let destinationController = segue.destination as! ProfileUpdateController
        if !newUser{
            destinationController.updateProfileButtontTitle = "Set a profile picture"
        }
        else{
            destinationController.updateProfileButtontTitle = "Update profile picture"
        }

        
    }
 
}
