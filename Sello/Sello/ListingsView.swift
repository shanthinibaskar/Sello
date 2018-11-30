//
//  CreateListingView.swift
//  Sello
//
//  Created by Devin Griffin on 11/15/18.
//  Copyright © 2018 Sello. All rights reserved.
//
extension UIColor { //from https://stackoverflow.com/a/48441178/7586688
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
import UIKit
import Foundation
import Firebase

class ListingsView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var listings: [Listing] = []
    var cachedImages: [UIImage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom", for: indexPath) as! CustomCollectionCell

        cell.label.text = listings[indexPath.row].title
        if(indexPath.row < cachedImages.count){
            cell.image.image = cachedImages[indexPath.row]
            cell.image.layer.cornerRadius = 30.0
            cell.image.layer.borderWidth = 3.0
            cell.image.layer.borderColor = UIColor.white.cgColor
            cell.image.layer.masksToBounds = true
//            cell.layer.cornerRadius = 5.0
//            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = UIColor.white.cgColor
//            cell.layer.masksToBounds = true
        }else{
            cell.image.image = UIColor.white.image()
        }

        return cell
    }
    func cacheImages(){
        for listing in listings{
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let imageRef = storageRef.child(listing.url)
            imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    print("FAIL!")
                    print(error)

                } else {
                    print("AN ERROR DID NOT OCCUR!")
                    let tempImage = UIImage(data: data!)
                    self.cachedImages.append(tempImage!)
                    self.collectionView.reloadData()
                }
            }
        }
        self.collectionView.reloadData()

    }
    override func viewDidAppear(_ animated: Bool) {
        cachedImages = []
        listings = []
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
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
                            var listing = try? decoder.decode(Listing.self, from: data)
                            listing!.url = document.documentID
                            self.listings.append(listing!);
                            print(self.listings);
                        }
                        
                    }
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    print("Listing size is: \(self.listings.count)")
                    self.cacheImages()
                }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

