//
//  ListingsView.swift
//  Sello
//
//  Created by labuser on 11/15/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit
import Firebase

class ListingsView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
     @IBOutlet weak var theCollectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = UIColor.black
        
        if (theImageCache.count != 0){
            cell.movieImage.image = theImageCache[indexPath.row]
        }
        
        if (movieResults.count != 0){
            cell.myLabel.text = movieResults[indexPath.row].title
            cell.overView.text = movieResults[indexPath.row].overview
            
        }
        return cell
    }
    
    var listings: [Listing] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theCollectionView.dataSource = self
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
        
        for
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
