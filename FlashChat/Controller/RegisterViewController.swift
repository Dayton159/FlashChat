//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
      //chain these two thing to do each optional binding. A comma means the same like && in if-else statement
            //it specify that if email textfield and password textword are both not nil do they execute
            //everything inside the curly bracket.
            if let email = emailTextfield.text, let password = passwordTextfield.text{
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        //it prints the description of the error that is localized to the language of the user
                        //selected for their phone. Phone with french language with display the error in french
                        print(e.localizedDescription)
                    }else{ // if you were successfully registered the user without an error,
                         
                        self.performSegue(withIdentifier: K.registerSegue, sender: self)
                        
                    }
                }
            }
             
    }
    
}

