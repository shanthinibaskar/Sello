//
//  SignupViewController.swift
//  Sello
//
//  Created by Admin on 25/11/2018.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    enum error {
        case success
        case invalidChar
        case notUniv
    }
    @IBOutlet weak var description: UILabel!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newUser: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        description.alpha = 0
        newPass.alpha = 0
        confirmPass.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let username = newUser.text
        let pass = newPass.text
        let confirm = confirmPass.text
        if(pass != confirm){
            description.text = "Passwords do not match"
            description.alpha = 1
            return
        }
        if(checkUser(username) == error.success){
            Auth.auth().createUser(withEmail: username, password: pass) { (authResult, error) in
                // ...
                guard let user = authResult?.user else { return }
                self.performSegue(withIdentifier: "SignIn", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "SignIn"){
            let destination = segue.destination as? SuccessViewController
        }
    }

}
