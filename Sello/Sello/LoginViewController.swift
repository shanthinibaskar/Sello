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
    @IBOutlet weak var schoolTextField: UITextField!
    
    var isLogin:Bool = true
    var alertNow: Bool = false {
        didSet {
            print("alertNow Set")
            alert(name: "Email Sent", message: "Please verify your account to log in")
        }
    }

    @IBAction func `switch`(_ sender: Any) {

        switch switchButton.selectedSegmentIndex{
            case 0:
                print("log")
                login.setTitle("Log In", for: UIControl.State())
                isLogin = true
            nameTextField.isHidden = true
            schoolTextField.isHidden = true
            case 1:
                print("Signup")
                login.setTitle("Sign Up", for: UIControl.State())
                isLogin = false
                nameTextField.isHidden = false
                schoolTextField.isHidden = false
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
    func alert(name: String, message: String){
        let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func loginUser(){
        guard let userEmail = email.text, let userPass = password.text else {
            print("Form is not valid")
            return
        }
        if userEmail == "" || userPass == ""{
            alert(name: "Error", message: "Enter email/password")
            return
        }
        
        
        Auth.auth().signIn(withEmail: userEmail, password: userPass, completion: { (user, error) in
            print(user)
            print(error)
            if error == nil{
                if user != nil && user!.user.isEmailVerified{
                    print("Signed In")
                    self.performSegue(withIdentifier: "LogIn", sender: self)
                }
                else if !user!.user.isEmailVerified{
                    self.alert(name: "Error", message: "Email is not verified")
                }
                else {
                    
                }
            }
            else{
                self.alert(name: "Error", message: "Incorrect Password")
            }
            
        })
    }
    func registerUser(){
        guard let userEmail = email.text, let userPass = password.text, let name = nameTextField.text, let schoolName = schoolTextField.text else {
            print("Form is not valid")
            return
        }
        if userEmail == "" || userPass == "" || name == "" || schoolName == ""{
            alert(name: "Error", message: "Missing values")
            return
        }
        if userPass.count < 6{
            alert(name: "Error", message: "Password must be greater than 6 characters")
            return
        }
        if checkUser(username: userEmail) == error.success{
            Auth.auth().createUser(withEmail: userEmail, password: userPass, completion: { (res, error) in
                
                if let error = error {
                    print("ERROR")
                    self.alert(name: "Error", message: error.localizedDescription)
                    return
                }
                if let user = res?.user {
                    Auth.auth().currentUser?.sendEmailVerification{(error) in
                        if error == nil {
                            guard let uid = res?.user.uid else {
                                return
                            }
                            let db = Firestore.firestore()
                            var ref1: DocumentReference? = nil
                            let tempFavorites = [""]
                            ref1 = db.collection("Favorites").addDocument(data: [
                                "userId": Auth.auth().currentUser?.uid ?? "XXXXX",
                                "favorites": tempFavorites,
                                
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document added with ID: \(ref1!.documentID)")
                                }
                            }
                            let ref = Database.database().reference()
                            let usersReference = ref.child("users").child(uid)
                            
                            let values = ["name": name, "email": userEmail, "school": schoolName]
                            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                
                                if let err = err {
                                    print(err)
                                    return
                                }
                                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                                self.dismiss(animated: true, completion: nil)
                            })
                            print("Email Sent")
                            self.alert(name: "Email is Sent", message: "Verify Email to Log in")
                        }
                        
                    }
                }
                
                //successfully authenticated user
                
                
                
            })
        }
        else{
            alert(name: "Error", message: "Email Address is not Valid")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if switchButton.selectedSegmentIndex == 0{
            isLogin = true
            nameTextField.isHidden = true
            schoolTextField.isHidden = true
        }
        else{
            isLogin = false
            nameTextField.isHidden = true
            schoolTextField.isHidden = true
        }
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
            self.alertNow = !self.alertNow
        })
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "LogIn"{
            let destination = segue.destination as! UITabBarController
            
        }
    }
}
