//
//  ProfileViewController.swift
//  Sello
//
//  Created by David Qiu on 12/1/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var image: UIButton!
    var profilePic: UIImage!
    @IBAction func changeImage(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image2 in
            self.profilePic = image2
            self.image.setImage(image2, for: .normal)
            self.uploadImage(name: Auth.auth().currentUser?.uid ?? "XXXXX")
        }
        
    }
    func loadProfilePic(){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(Auth.auth().currentUser?.uid ?? "XXXXX")
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let tempImage = UIImage(data: data!)
                self.image.setImage(tempImage, for: .normal)
            }
        }
    }
    func uploadImage(name: String){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var data = Data()
        data = UIImageJPEGRepresentation(profilePic, 0.8)!
        
        
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.child("/\(name)/").putData(data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print("THERE IS AN ERROR!")
                    print(error.localizedDescription)
                    return
                }
                print("NO ERROR!!")

                
            }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfilePic()
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name.text = value?["name"] as! String
            self.school.text = value?["school"] as! String
            self.email.text = value?["email"] as! String

//            let username = value?["username"] as? String ?? ""
//            let user = User(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
