//
//  Listing.swift
//  Sello
//
//  Created by Devin Griffin on 11/15/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import Foundation

struct Listing: Codable{
    var userId: String;
    var type: String;
    var title: String;
    var description: String;
    var url: String;
}
