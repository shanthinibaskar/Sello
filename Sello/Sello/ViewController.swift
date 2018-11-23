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
    
    
    
    
    override func viewDidLoad() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        super.viewDidLoad()
        let db = Firestore.firestore()

        let decoder = JSONDecoder()

        db.collection("listings").whereField("url", isEqualTo: "www.fake.com")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("made it here")
                        print("\(document.documentID) => \(document.data())")
                        if let data = try?  JSONSerialization.data(withJSONObject: document.data(), options: []) {
                            let listing = try? decoder.decode(Listing.self, from: data)
                            self.listings.append(listing!);
                            print(self.listings);
                        }
                        
                    }
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

