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
//        window = UIWindow(frame:UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = UINavigationController(rootViewController: MessagesController())
        
        
        super.viewDidLoad()
//        let db = Firestore.firestore()
//
//        let decoder = JSONDecoder()
//
//        db.collection("listings").whereField("url", isEqualTo: "www.fake.com")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("made it here")
//                        print("\(document.documentID) => \(document.data())")
//                        if let data = try?  JSONSerialization.data(withJSONObject: document.data(), options: []) {
//                            let listing = try? decoder.decode(Listing.self, from: data)
//                            self.listings.append(listing!);
//                            print(self.listings);
//                        }
//
//                    }
//                }
//        }
        
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

