//
//  VerifyViewController.swift
//  Sello
//
//  Created by Admin on 25/11/2018.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBAction func verify(_ sender: Any) {
        let email = emailText.text
        if Auth.auth().
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
