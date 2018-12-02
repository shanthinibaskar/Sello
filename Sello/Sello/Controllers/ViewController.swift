//
//  ViewController.swift
//  Sello
//
//  Created by Shanthini Baskar on 7/11/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController{
    var listings: [Listing] = []
    
    var window: UIWindow?
    var didShow:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        if !didShow{

            let loginController = UINavigationController(rootViewController: MessagesController())
            present(loginController, animated: true, completion: nil)
            didShow = true
        }
        else{
            self.performSegue(withIdentifier: "goProfile", sender: self)
            didShow = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

