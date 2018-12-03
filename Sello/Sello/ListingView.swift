//
//  ListingView.swift
//  Sello
//
//  Created by Devin Griffin on 11/29/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit
import Firebase

class ListingView: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detailsView: UILabel!
    @IBAction func chat(_ sender: Any) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        let userid = listing.userId
//        let storage = Storage.storage()
//        let profileRef = storage.reference().child(userid ?? "XXXX")
//        // Fetch the download URL
//        profileRef.downloadURL { url, error in
//            if let error = error {
//                print(error)
//
//            } else {
//                chatLogController.storedurl = url
//            }
//        }
//        chatLogController.userid = userid
//        navigationController?.pushViewController(chatLogController, animated: true)
        let storage = Storage.storage()
        let profileRef = storage.reference().child(userid)
        // Fetch the download URL
        profileRef.downloadURL {url, error in
            if let error = error {
                print(error)
                
            } else {
                
                chatLogController.storedURL = url
                chatLogController.loadImage()
                chatLogController.userid = userid
                self.navigationController?.pushViewController(chatLogController, animated: true)
            }
        }
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var listing: Listing!
    var image: UIImage!
    override func viewDidLoad() {
        imageView.image = image
        name.text = listing.title
        detailsView.text = listing.description
        if(listing.userId != Auth.auth().currentUser?.uid ?? "XXXXX"){
            editButton.isHidden = true;
            deleteButton.isHidden = true;
        }else{
            chatButton.isHidden = true;
        }
        super.viewDidLoad()
    }
    
    @IBAction func editListing(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateListingsView
        myVC.listing = listing
        myVC.editingListing = true
        myVC.editedImage = image
        navigationController?.popViewController(animated: true)
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    @IBAction func deleteListing(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(listing.url)
        let db = Firestore.firestore()
        
        imageRef.delete { error in
            if let error = error {
                print(error)
            }
        }
        db.collection("listings").document(listing.url).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        navigationController?.popViewController(animated: true)
        
    }
}
