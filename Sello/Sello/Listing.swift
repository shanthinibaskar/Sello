//
//  Listing.swift
//  Sello
//
//  Created by Devin Griffin on 11/15/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import Foundation

struct Listing: Codable{
    var userId: String
    var type: String
    var title: String
    var description: String
    var url: String
//    init(userId: String, type: String,title: String, description: String, url: String) {
//        self.userId = userId
//        self.type = type
//        self.title = title
//        self.description = description
//        self.url = url
//    }
    init() {
        self.userId = ""
        self.type = ""
        self.title = ""
        self.description = ""
        self.url = ""
    }
}
