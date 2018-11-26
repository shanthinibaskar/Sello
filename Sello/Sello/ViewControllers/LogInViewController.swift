//
//  ViewController.swift
//  Sello
//
//  Created by Shanthini Baskar on 7/11/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupbutton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        username.addTarget(
            self,
            action: #selector(textFieldDidReturn),
            for: .primaryActionTriggered
        )
        
        password.addTarget(
            self,
            action: #selector(textFieldDidReturn),
            for: .primaryActionTriggered
        )
        
        email.addTarget(
            self,
            action: #selector(textFieldDidReturn),
            for: .primaryActionTriggered
        )
        
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        username.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func actionButtonPressed() {
        signUp()
    }
    
    @objc private func textFieldDidReturn() {
        signUp()
    }
    
    // MARK: - Helpers
    
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    private func signUp() {
        guard let name = username.text, !name.isEmpty else {
            showMissingNameAlert()
            return
        }
        
        username.resignFirstResponder()
        
        AppSettings.username = name
        Auth.auth().signInAnonymously(completion: nil)
    }
    
    private func showMissingNameAlert() {
        let ac = UIAlertController(title: "Display Name Required", message: "Please enter a display name.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.username.becomeFirstResponder()
            }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - Notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if (notification.userInfo?.!isEmpty) {
            let userInfo = notification.userInfo
            if (UIKeyboardFrameEndUserInfoKey.!isEmpty) {
                keyboardHeight = (userInfo[UIkeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            if (UIKeyboardAnimationDurationUserInfoKey.!isEmpty) {
                let keyboardAnimationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
                UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            if (UIKeyboardAnimationCurveUserInfoKey.!isEmpty) {
               let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
                let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
                bottomConstraint.constant = keyboardHeight + 20
            }
        }
        else {
            return
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        guard let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            return
        }
        
        let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve << 16)
        bottomConstraint.constant = 20
        
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

