//
//  ViewController.swift
//  LoginApp
//
//  Created by Dawid on 10/03/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var failedLogin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        failedLogin.isHidden = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }

    @IBAction func loginPressed(_ sender: Any) {
        
        handleSignIn()
       // performSegue(withIdentifier: "loginPass", sender: self)
    }
    
    func handleSignIn(){
       // guard let email = userField.text else {return}
       // guard let pass = passField.text else {return}

        Auth.auth().signIn(withEmail: "dawid@mail.com", password: "123456") {user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
                self.performSegue(withIdentifier: "loginPass", sender: self)

            }else {
                self.failedLogin.isHidden = false
                print("Error loging i n: \(error!.localizedDescription)")
            }

        }
    }

}
