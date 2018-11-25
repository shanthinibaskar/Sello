//
//  LoginViewController.swift
//  Sello
//
//  Created by Admin on 24/11/2018.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var login: UIButton!

    @IBAction func loginPress(_ sender: Any) {
        let user = username.text
        let pass = password.text
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if (user != nil && user.isEmailVerified){
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
            }
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUp", sender: self)
    }
    @IBAction func forgotPass(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotPass", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.performSegue(withIdentifier: "LoginSuccess", sender: self)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginSuccess"){
            let bar = segue.destination as? UITabBarController
        }
        if(segue.identifier == "forgotPass"){
            let destination = segue.destination as? ForgotPassViewController
        }
        if(segue.identifier == "SignUp"){
            let destination = segue.destination as? SignupViewController
        }
    }
  

}
