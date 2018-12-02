//
//  Util.swift
//  Sello
//
//  Created by David Qiu on 12/1/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import Foundation
import UIKit

func alert(name: String, message: String){
    let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
}

