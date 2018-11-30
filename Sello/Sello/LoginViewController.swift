//
//  LoginViewController.swift
//  Sello
//
//  Created by Admin on 24/11/2018.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    enum error {
        case success
        case invalidChar
        case notUniv
    }
    var Login:Bool = false;
    let db = Firestore.firestore()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var verify: UILabel!
    
    @IBOutlet weak var login: UIButton!

    @IBAction func loginPress(_ sender: Any) {
        guard let userEmail = username.text else{
            return
        }
        guard let password = password.text else{
            return
        }
        if(userEmail == "" || password == ""){
            return
        }

        Auth.auth().signIn(withEmail: userEmail, password: password) { (users, error) in
            if error == nil {
                if users != nil && users!.user.isEmailVerified{
                    print("Signed In")
                    self.performSegue(withIdentifier: "LoginSuccess", sender: self)
                }
            }
        }
        
    }
    func isValid(char: Character) -> Bool{
        if(char >= "A" && char <= "Z"){
            return true
        }
        if(char >= "a" && char <= "z"){
            return true
        }
        if(char >= "0" && char <= "9"){
            return true
        }
        if(char == "." || char == "+" || char == "_"){
            return true
        }
        return false
    }
    func checkUser(username: String) -> error{
        var after = false
        var first = true
        var prev: Character = "A"
        for char in username{
            if(first){
                prev = char
                first = false
            }
            if(!after){
                if(char == "@"){
                    after = true
                }
                else{
                    if(!isValid(char: char)){
                        return error.invalidChar
                    }
                    if(char == "." && char == prev){
                        return error.invalidChar
                    }
                }
            }
            else{
                if(char == "@"){
                    return error.invalidChar
                }
                else{
                    if(!isValid(char: char)){
                        return error.invalidChar
                    }
                    if(char == "." && char == prev){
                        return error.invalidChar
                    }
                }
            }
            prev = char
        }
        let last = username.suffix(4)
        if(last != ".edu"){
            return error.notUniv
        }
        return error.success
    }
    @IBAction func signs(_ sender: UIButton) {
        guard let userEmail = username.text else{
            return
        }
        guard let password = password.text else{
            return
        }
        if(userEmail == "" || password == ""){
            return
        }
        if(checkUser(username: userEmail) == error.success){
            print("check")
            Auth.auth().createUser(withEmail: userEmail, password: password) { (authResult, error) in
                // ...
                if let user = authResult?.user {
                    Auth.auth().currentUser?.sendEmailVerification{(error) in
                        if error == nil {
                            print("Email Sent")
                        }
                        
                    }
                }
            }
        }
    }
    @IBAction func forgotPass(_ sender: Any) {
        //self.performSegue(withIdentifier: "forgotPass", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        verify.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginSuccess"){
            let bar = segue.destination as? UITabBarController
            let usersDB = db.collection("UserInfo")
            userDB.
        }
        else if(segue.identifier == "forgotPass"){
            let destination = segue.destination as? ForgotPassViewController
        }
        else if(segue.identifier == "SignUps"){
            let destination = segue.destination as? SignupViewController
        }
    }
  

}
