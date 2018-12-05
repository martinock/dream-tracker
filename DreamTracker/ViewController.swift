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
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var isLoginValid = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
                    indicator.startAnimating()
                    Alamofire
                        .request("http://93.188.167.250:8080/login", method: .post, parameters: [
                            "email": username,
                            "password": password
                            ], encoding: JSONEncoding.default)
                        .responseJSON { response in
                            switch response.result {
                            case .success(_):
                                self.indicator.stopAnimating()
                                if let data = response.data {
                                    do {
                                        let mappedResponse = try jsonDecoder.decode(LoginData.self, from: data)
                                        if (mappedResponse.success) {
                                            print(mappedResponse.data?.token ?? "token");
                                            
                                            //Store token in userDefault
                                            let userDefault = UserDefaults.standard;
                                            userDefault.set(mappedResponse.data?.token, forKey: "token")
                                            
                                            self.isLoginValid = true
                                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                                        } else {
                                            let alert = UIAlertController(title: "Authentication Error", message: mappedResponse.error ?? "Please check your username/password and try again", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                                _ in
                                            }))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    } catch let error {
                                        print(error)
                                    }
                                }
                                break;
                                
                            case .failure(let error):
                                self.indicator.stopAnimating()
                                var messageError = "Failure"
                                //NOTE: how to get error code
                                if error._code == NSURLErrorNotConnectedToInternet {
                                    messageError = "No internet connection"
                                }
                                let alert = UIAlertController(title: "Failure", message: messageError, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    _ in
                                }))
                                self.present(alert, animated: true, completion: nil)
                                break;
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

