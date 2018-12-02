//
//  LoginViewController.swift
//  Sello
//
//  Created by David Qiu on 12/1/18.
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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var switchButton: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var isLogin:Bool = true
    
    @IBAction func `switch`(_ sender: Any) {

        switch switchButton.selectedSegmentIndex{
            case 0:
                print("log")
                login.setTitle("Log In", for: UIControl.State())
                isLogin = true
            case 1:
                print("Signup")
                login.setTitle("Sign Up", for: UIControl.State())
                isLogin = false
            default:
                break
        }
        
        
    }
    
    @IBOutlet weak var login: UIButton!
    
    @IBAction func logInPress(_ sender: Any) {
        if(isLogin){
            loginUser()
        }
        else{
            registerUser()
        }
    }
    func loginUser(){
        guard let userEmail = email.text, let userPass = password.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: userEmail, password: userPass, completion: { (user, error) in
            if error == nil{
                if user != nil && user!.user.isEmailVerified{
                    print("Signed In")
                    self.performSegue(withIdentifier: "LogIn", sender: self)
                }
                else if !user!.user.isEmailVerified{
                    let alert = UIAlertController(title: "Email not verfified", message: "This is an alert.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Password not correct", message: "This is an alert.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    func registerUser(){
        guard let userEmail = email.text, let userPass = password.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        if checkUser(username: userEmail) == error.success{
            Auth.auth().createUser(withEmail: userEmail, password: userPass, completion: { (res, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                if let user = res?.user {
                    Auth.auth().currentUser?.sendEmailVerification{(error) in
                        if error == nil {
                            guard let uid = res?.user.uid else {
                                return
                            }
                            
                            let ref = Database.database().reference()
                            let usersReference = ref.child("users").child(uid)
                            let values = ["name": name, "email": userEmail]
                            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                
                                if let err = err {
                                    print(err)
                                    return
                                }
                                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                                self.dismiss(animated: true, completion: nil)
                            })
                            print("Email Sent")
                        }
                        
                    }
                }
                
                //successfully authenticated user
                
                
                
            })
        }
        else{
            let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if switchButton.selectedSegmentIndex == 0{
            isLogin = true
        }
        else{isLogin = false}
        // Do any additional setup after loading the view.
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
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            //            self.messagesController?.fetchUserAndSetupNavBarTitle()
            //            self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User(dictionary: values)
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
