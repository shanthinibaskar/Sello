//
//  SuccessViewController.swift
//  Sello
//
//  Created by Admin on 25/11/2018.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "goLogin", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goLogin"){
            let destination = segue.destination as? LoginViewController
            destination?.username.text = ""
            destination?.password.text = ""
        }
    }
  
}
