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
    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
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
            if let email = usernameTextField.text {
                if email.isEmpty {
                    let alert = UIAlertController(title: "Authentication Error", message: "Username is required", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return false;
                }
                if let password = passwordTextField.text {
                    if password.isEmpty {
                        let alert = UIAlertController(title: "Authentication Error", message: "Password is required", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            _ in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return false
                    }
                    let jsonDecoder = JSONDecoder()
                    indicator.startAnimating()
                    Alamofire
                        .request("http://93.188.167.250:8080/login", method: .post, parameters: [
                            "email": email,
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
                                            //Store token in userDefault
                                            let userDefault = UserDefaults.standard;
                                            userDefault.set(mappedResponse.data?.token, forKey: "token")
                                            userDefault.set(email, forKey: "email")
                                            userDefault.set(true, forKey: "isLogin")
                                            
                                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                                        } else {
                                            //Show alert when error
                                            let alert = UIAlertController(title: "Authentication Error", message: mappedResponse.error ?? "Please check your email/password and try again", preferredStyle: .alert)
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
                                
                                //Show alert when error
                                var messageError = "Failure"
                                if error._code == NSURLErrorNotConnectedToInternet {
                                    messageError = "No internet connection"
                                }
                                let alert = UIAlertController(title: "Failure", message: messageError, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    _ in
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                }
            }
            return false
        case "registerSegue":
            if let name = newUsernameTextField.text {
                if name.isEmpty {
                    let alert = UIAlertController(title: "Authentication Error", message: "Username is required", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
                if let email = newEmailTextField.text {
                    if email.isEmpty {
                        let alert = UIAlertController(title: "Authentication Error", message: "Email is required", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            _ in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return false
                    }
                    if let password = newPasswordTextField.text {
                        if password.isEmpty {
                            let alert = UIAlertController(title: "Authentication Error", message: "Password is required", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                _ in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            return false
                        }
                        let jsonDecoder = JSONDecoder()
                        indicator.startAnimating()
                        Alamofire
                            .request("http://93.188.167.250:8080/register", method: .post, parameters: [
                                "name": name,
                                "email": email,
                                "password": password
                                ], encoding: JSONEncoding.default)
                            .responseJSON { response in
                                switch response.result {
                                case .success(_):
                                    self.indicator.stopAnimating()
                                    if let data = response.data {
                                        do {
                                            let mappedResponse = try jsonDecoder.decode(RegisterData.self, from: data)
                                            
                                            if (mappedResponse.success) {
                                                //Store token in userDefault
                                                let userDefault = UserDefaults.standard
                                                userDefault.set(mappedResponse.data?.id, forKey: "userID")
                                                userDefault.set(mappedResponse.data?.name, forKey: "userName")
                                                userDefault.set(mappedResponse.data?.email, forKey: "email")
                                                userDefault.set(true, forKey: "isLogin")
                                                
                                                self.performSegue(withIdentifier: "registerSegue", sender: self)
                                            } else {
                                                //Show alert when error
                                                let alert = UIAlertController(title: "Register Error", message: mappedResponse.error ?? "Please check your field and try again", preferredStyle: .alert)
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
                                    
                                    //Show alert when error
                                    var messageError = "Failure"
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
            }
            return false
        default:
            return true
            //do nothing
        }
    }


}

