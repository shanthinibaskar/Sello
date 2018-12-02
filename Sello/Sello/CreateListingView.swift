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

class CreateListingsView: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    var listing: Listing!
    var editedImage: UIImage!
    var editingListing = false
    var image: UIImage = UIImage()
    var category = "Textbooks";
    var categories = ["Textbooks","Transportation","Clothes","Furniture","Technology","Other"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var desc: UITextField!
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    
    @IBAction func selectPicture(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.image = image
        }
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func createListing(_ sender: Any) {
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
        if(!editingListing){
                ref = db.collection("listings").addDocument(data: [
                    "userId": "xxxxxx",
                    "type": category,
                    "title": name.text!,
                    "description": desc.text!,
                    "url": "www.fake.com"
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            uploadImage(name: ref!.documentID)

        }else{
            db.collection("listings").document(listing.url).updateData([
                "type": category,
                "title": name.text!,
                "description": desc.text!
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
                
            print(listing.url)
            uploadImage(name: listing.url)

            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func uploadImage(name: String){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var data = Data()
        data = UIImageJPEGRepresentation(image, 0.8)!
        
        if(editingListing){
            let imageRef = storageRef.child(listing.url)
            imageRef.delete { error in
                    print("made it")
                if let error = error {
                    print(error)
                }else{
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    storageRef.child("/\(name)/").putData(data, metadata: metaData){(metaData,error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                    }
                }
            }
        }else{
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child("/\(name)/").putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        if(!editingListing){
            ImagePickerManager().pickImage(self){ image in
                self.image = image
            }
        }else{
            submit.setTitle("Update Listing", for: UIControlState.normal)
            name.text = listing.title
            desc.text = listing.description
            image = editedImage
            category = listing.type
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(editingListing){
        let index = categories.index(of: listing.type)
        picker.selectRow(index!, inComponent: 0, animated: true)
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        category = categories[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}

