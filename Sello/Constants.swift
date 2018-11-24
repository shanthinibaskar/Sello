//
//  Constants.swift
//  Sello
//
//  Created by Shanthini Baskar on 24/11/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
