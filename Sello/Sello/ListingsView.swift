//
//  CreateListingView.swift
//  Sello
//
//  Created by Devin Griffin on 11/15/18.
//  Copyright © 2018 Sello. All rights reserved.
//
import UIKit
import Foundation
import Firebase

class ListingsView: UIViewController {
    
    @IBOutlet weak var testImage: UIImageView!
    
    override func viewDidLoad() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        super.viewDidLoad()
        let islandRef = storageRef.child("images")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("FAIL!")
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                print("AN ERROR DID NOT OCCUR!")
                
                self.testImage.image = UIImage(data: data!)
            }
        }
    }
    
}

