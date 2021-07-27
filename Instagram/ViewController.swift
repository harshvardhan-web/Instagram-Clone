//
//  ViewController.swift
//  Instagram
//
//  Created by harshvardhan singh on 8/18/19.
//  Copyright © 2019 harshvardhan singh. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var switchLogin: UIButton!
    @IBOutlet weak var signupOrLogin: UIButton!
    @IBOutlet weak var alreadyLabel: UILabel!
    
    var signupModeActive = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil{
            
            self.performSegue(withIdentifier: "showUser", sender: self)
            
        }
        self.navigationController?.navigationBar.isHidden = true
        
    }

    @IBAction func signupOrLoginButton(_ sender: Any) {
        
        if email.text == "" || password.text == ""{
            
            self.displayAlert("Warning!",message: "Please enter an Email and Password")
            
        }else{
            
            //let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            //activityIndicator.center = self.view.center
            //activityIndicator.hidesWhenStopped = true
            //activityIndicator.style = UIActivityIndicatorView.Style.gray
            
            //view.addSubview(activityIndicator)
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive){
                
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                let user = PFUser()
                
                user.username = email.text
                user.password = password.text
                user.email = email.text
                // other fields can be set just like with PFObject
                //user["phone"] = "415-392-0202"
                
                user.signUpInBackground { (success, error) in
                    
                    if error != nil {
                        
                        self.displayAlert("Could not Sign you up!",message: error!.localizedDescription)
                        
                        print("Error")
                        
                    } else {
                        // Hooray! Let them use the app now.
                        print("signed up")
                        
                        self.performSegue(withIdentifier: "showUser", sender: self)
                        
                        }
                    }
            }else{
                
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
                    
                    if user != nil {
                        // Do stuff after successful login.
                        
                        self.performSegue(withIdentifier: "showUser", sender: self)

                        // self.displayAlert("Logged In", message: "You have been successfully logged in")
                        
                    } else {
                        // The login failed. Check error to see why.
                        self.displayAlert("Login Failed", message: error!.localizedDescription)
                    }
                    
                }
            
            }
            
        }
    }
    
    func displayAlert(_ title: String,message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func switchLoginButton(_ sender: Any) {
        
        if signupModeActive == true{
            
            signupModeActive = false
            signupOrLogin.setTitle("Login", for: UIControl.State.normal)
            
            switchLogin.setTitle("Signup", for: UIControl.State.normal)
            
           alreadyLabel.text = "New member?"
            
        }else{
            
            signupModeActive = true
            signupOrLogin.setTitle("Signup", for: UIControl.State.normal)
            
            switchLogin.setTitle("Login", for: UIControl.State.normal)
            
            alreadyLabel.text = "Already a member?"
            
        }
        
    }
    
}

