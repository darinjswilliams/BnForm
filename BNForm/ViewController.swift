//
//  ViewController.swift
//  BNForm
//
//  Created by Darin Williams on 10/4/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    @IBOutlet var signInSelector: UISegmentedControl!
    
    
    @IBOutlet var signInLabel: UILabel!
    
   
    @IBOutlet var emailAddressField: UITextField!
    
    @IBOutlet var passWordField: UITextField!
    
    
    @IBOutlet var signInRegisterButton: UIButton!
    
    
  
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fbLoginButton = FBSDKLoginButton()
        
        view.addSubview(fbLoginButton)
        
        fbLoginButton.frame = CGRect(x: 20, y: 510, width: view.frame.width - 32, height: 40)
        
        fbLoginButton.delegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of facebook")
    }

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil{
            print(error)
            return
        }else{
            print("Logged in Successfully with facebook")
             self.performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInSelectorChange(_ sender: UISegmentedControl) {
        
        //Flip boolean to false
        isSignIn = !isSignIn
        
        //check boolean value and set the button and label
        if isSignIn{
            signInLabel.text = "Sign In"
            
            //Change title on Button to Sign in
            signInRegisterButton.setTitle("Sign In", for: .normal)
            
        }else{
            signInLabel.text="Register"
            signInRegisterButton.setTitle("Register", for: .normal)
        }
        
    }
   
  
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if let emailAddr = self.emailAddressField.text, let passWrd = self.passWordField.text{
            
            //Check if it is sign in or register
            if isSignIn{
                //Sign in user with Firebase
                
                 self.performSegue(withIdentifier: "goToHome", sender: self)
                Auth.auth().signIn(withEmail: emailAddr, password: passWrd, completion: { (user, error) in
                
                    //Check to see if user is not nil
                    if let u = user{
                        // User is found go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
                    }else{
                        //Error occurred Check Error and show message
                        
                    }
                    
                })
                
            }else{
                //Register the User with Firebase
                
                self.performSegue(withIdentifier: "goToHome", sender: self)
                

                
                Auth.auth().createUser(withEmail: emailAddr, password: passWrd, completion: { (user, error) in
                    
                    //Check to see if user is not nil
                    if let u = user{
                        // User is found go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        
                    }else{
                        //Error occurred Check Error and show message
                        
                    }
                    
                })
                
               
                
            }

            
        }
        
    }

    
    //Dismiss keyboard so it does not cover submit button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailAddressField.resignFirstResponder()
        passWordField.resignFirstResponder()
    }
}

