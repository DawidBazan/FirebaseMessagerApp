//
//  SignUpViewController.swift
//  LoginApp
//
//  Created by Dawid on 10/03/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var passConfirmField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        signUpBtn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func handleSignUp(){
        
        guard let userName = userField.text else {return}
        guard let email = emailField.text else {return}
        guard let pass = passField.text else {return}
        
        signUpBtn.setTitle("", for: .normal)
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        self.dismiss(animated: false, completion: nil)
                    } else {
                        print("Error: \(error!.localizedDescription)")
                    }
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
}
