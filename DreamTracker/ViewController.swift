//
//  ViewController.swift
//  DreamTracker
//
//  Created by Ferico Samuel on 12/09/18.
//  Copyright © 2018 Tokopedia. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isLoginValid = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "loginSegue":
            if let username = usernameTextField.text {
                if username.isEmpty {
                    return false
                }
                if let password = passwordTextField.text {
                    if password.isEmpty {
                        return false
                    }
                    let jsonDecoder = JSONDecoder()
                    Alamofire
                        .request("http://93.188.167.250:8080/login", method: .post, parameters: [
                            "email": username,
                            "password": password
                            ], encoding: JSONEncoding.default)
                        .responseJSON { response in
                            if let data = response.data {
                                do {
                                    let mappedResponse = try jsonDecoder.decode(LoginData.self, from: data)
                                    print(mappedResponse.data?.token ?? "token");
                                    //Store token in storage 
                                    self.isLoginValid = true
                                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                                } catch let error {
                                    print(error)
                                }
                            }
                        }
                }
            }
            return isLoginValid
        
        default:
            return false
            //do nothing
        }
    }


}

