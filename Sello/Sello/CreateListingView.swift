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
    
    
    var image: UIImage = UIImage()
    var category = "";
    var categories = ["Laptop","Car","Textbook"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
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
//            uploadImage()
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
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
    }
    
    func uploadImage(name: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var data = Data()
        data = UIImageJPEGRepresentation(image, 0.8)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child("/\(name)/").putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        ImagePickerManager().pickImage(self){ image in
            self.image = image
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        category = categories[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}

