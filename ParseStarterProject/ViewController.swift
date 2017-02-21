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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let object = PFObject(className: "Test")
        object.add("Viraj", forKey: "name")
        object.add("26", forKey: "age")
        object.add("Male", forKey: "gender")
        
        object.saveInBackground { (saved, error) in
            if error != nil{
                print("Error\(error)")
            }
            else if saved{
                print("saved object check dash board")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
