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
    var favorites: Favorites!
    @IBAction func chat(_ sender: Any) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        let userid = listing.userId
        chatLogController.userid = userid
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    
    @IBAction func favoriteListing(_ sender: Any) {
        let db = Firestore.firestore()
        let decoder = JSONDecoder()
        var docID = ""
        db.collection("Favorites").whereField("userId", isEqualTo: Auth.auth().currentUser?.uid ?? "XXXXX")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let data = try?  JSONSerialization.data(withJSONObject: document.data(), options: []) {
                            self.favorites = try? decoder.decode(Favorites.self, from: data)
                            print(self.favorites);
                            docID = document.documentID
                            if(self.favorites.favorites.contains(self.listing.url) == false){
                        self.favorites.favorites.append(self.listing.url)
                            }else{
                                let index = self.favorites.favorites.firstIndex(of: self.listing.url)
                                self.favorites.favorites.remove(at: index!)

                            }
                        }
                        
                    }
                    print(self.favorites.favorites)
                    db.collection("Favorites").document(docID).updateData([
                        "favorites": self.favorites.favorites,
                        
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                   
                    
                }
        }
    }
    
    
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
