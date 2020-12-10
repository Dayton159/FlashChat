//
//  LoginViewController.swift
//  FlashChat
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        //the firebase login method has a default [weak self] and guard self which we removed at first.
        
        // Escaping closures require [weak self] if they get stored somewhere
        //or get passed to another closure and an object inside them keeps a reference to the closure
        
        //guard let self = self can lead to delayed deallocation in some cases, which
        //can be good or bad depending on your intentions
     if let email = emailTextfield.text, let password = passwordTextfield.text {
                 Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                     if let e = error{
                      print(e.localizedDescription)
                     }else{
                        self.performSegue(withIdentifier: K.loginSegue, sender: self)
                     }
                   
                 }
                 }
           }
           
       }
