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
    
    let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUpProcess(_ sender: Any) {
        if signupButton.titleLabel?.text == "Sign Up"{
            print("Sign Up")
            //add user
            let user  = PFUser()
            user.username = username.text
            user.password = password.text
            user.signUpInBackground(block: { (saved, error) in
                if error != nil{
                    if let error  = error{
                        let errorMessage = error.localizedDescription
                        print(errorMessage)
                        self.alert.title = "Opps"
                        if errorMessage.contains("already exists"){
                            self.alert.message = errorMessage
                        }
                        else{
                            self.alert.message = "Something weird happened. Try siginin up in sometime"
                        }
                        
                        self.alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (alerted) in
                        self.alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(self.alert, animated: true, completion: nil)
                        self.username.text = ""
                        self.password.text = ""
                    }
                    
                }
                else{
                    print("saved")
                    //notify the user
                    self.alert.title = "Success"
                    self.alert.message = "Thanks for signin up"
                    self.alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (okPressed) in
                        self.alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(self.alert, animated: true, completion: nil)
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
                    print(error?.localizedDescription)
                    //notify the user
                    self.alert.title = "Opps"
                    self.alert.message = error?.localizedDescription
                    self.alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (okPressed) in
                        self.alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(self.alert, animated: true, completion: nil)
                    self.username.text = ""
                    self.password.text = ""
                }
                else if let loggedInUser = loggedIn{
                    print(loggedInUser)
                    //notify the user
                    print("User logged in")

                }
            })
           
            
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
}
