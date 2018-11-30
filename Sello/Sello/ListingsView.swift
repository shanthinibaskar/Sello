//
//  CreateListingView.swift
//  Sello
//
//  Created by Devin Griffin on 11/15/18.
//  Copyright © 2018 Sello. All rights reserved.
// Icon color: 3E5A8F Icon background color: F6F7EC Category text color : ACA8A9

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

class ListingsView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categories: UIView!
    var hidden = true
    var listings: [Listing] = []
    var imageDict: [String: UIImage] = [:]

    var cachedImages: [UIImage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text! == ""){
            getAllListings()
        }else{
            searchListings(search: searchBar.text!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailedVC = ListingView()
//        detailedVC.image.image = UIColor.red.image()!
//        detailedVC.image.image = imageDict[listings[indexPath.row].url]
//        detailedVC.name.text = listings[indexPath.row].title
//        navigationController?.pushViewController(detailedVC, animated: true)
        let vc = ListingView(
            nibName: "ListingView",
            bundle: nil)
        vc.image.image = UIColor.red.image()
        vc.name.text = "123"
        navigationController?.pushViewController(vc,
                                                 animated: true )

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom", for: indexPath) as! CustomCollectionCell
        cell.label.text = listings[indexPath.row].title
        if(indexPath.row < cachedImages.count){
//            cell.image.image = cachedImages[indexPath.row]
            cell.image.image = imageDict[listings[indexPath.row].url]
            cell.image.layer.cornerRadius = 30.0
            cell.image.layer.borderWidth = 3.0
            cell.image.layer.borderColor = UIColor.white.cgColor
            cell.image.layer.masksToBounds = true
        }else{
            cell.image.image = UIColor.red.image()
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
                    print(error)
                } else {
                    let tempImage = UIImage(data: data!)
                    self.imageDict[listing.url] = tempImage!
                    self.cachedImages.append(tempImage!)
                    self.collectionView.reloadData()
                }
            }
        }
        self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.categories.isHidden = true;
        getAllListings()
    }
    func getAllListings(){
        
        cachedImages = []
        listings = []
        let db = Firestore.firestore()
        let decoder = JSONDecoder()
        
        db.collection("listings") //.whereField("type", isEqualTo: "Textbook")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let data = try?  JSONSerialization.data(withJSONObject: document.data(), options: []) {
                            var listing = try? decoder.decode(Listing.self, from: data)
                            listing!.url = document.documentID
                            self.listings.append(listing!);
                            print(self.listings);
                        }
                        
                    }
                    self.searchBar.delegate = self
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    print("Listing size is: \(self.listings.count)")
                    self.cacheImages()
                }
        }
    }
    func searchListings(search: String){
        if(search != ""){
        self.cachedImages = []
        var tempListings: [Listing] = []
        for list in listings{
            if((list.title.lowercased().range(of: search.lowercased())) != nil){
                tempListings.append(list)
            }
        }
        listings = tempListings
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.cacheImages()
        }
        
    }
    
    func getListings(catergory: String){
        cachedImages = []
        listings = []
        let db = Firestore.firestore()
        let decoder = JSONDecoder()
        db.collection("listings").whereField("type", isEqualTo: catergory)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let data = try?  JSONSerialization.data(withJSONObject: document.data(), options: []) {
                            var listing = try? decoder.decode(Listing.self, from: data)
                            listing!.url = document.documentID
                            self.listings.append(listing!);
                            
                        }
                        
                    }
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.cacheImages()
                }
        }
    }
    @IBAction func textbooks(_ sender: Any) {
        self.categories.isHidden = true;
        getListings(catergory: "Textbooks")
    }
    @IBAction func transportation(_ sender: Any) {
        self.categories.isHidden = true;
        getListings(catergory: "Transportation")
    }
    
    @IBAction func clothes(_ sender: Any) {
        self.categories.isHidden = true;
        getListings(catergory: "Clothes")
    }
    
    
    @IBAction func furniture(_ sender: Any) {
        self.categories.isHidden = true;
        getListings(catergory: "Furniture")

    }
    @IBAction func technology(_ sender: Any) {
        self.categories.isHidden = true;
        getListings(catergory: "Technology")

    }

    @IBAction func other(_ sender: Any) {
        self.categories.isHidden = true;
        getListings(catergory: "Other")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func categories(_ sender: Any) {
        if(hidden){
            self.categories.isHidden = false;
            hidden = false;
        }else{
            self.categories.isHidden = true;
            hidden = true;
        }

    }
    
}

