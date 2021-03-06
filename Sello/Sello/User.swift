//
//  User.swift
//  Sello
//
//  Created by Shanthini Baskar on 27/11/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit

class User: NSObject, Decodable {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}

