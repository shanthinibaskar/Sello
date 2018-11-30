//
//  tableVC.swift
//  Sello
//
//  Created by labuser on 11/29/18.
//  Copyright © 2018 Sello. All rights reserved.
//

import UIKit

class sideTableVC: UITableViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name("showSideMenu"), object: nil)
        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name("showProfile"), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name("showFavorites"), object: nil)
        case 2: NotificationCenter.default.post(name: NSNotification.Name("showMessaging"), object: nil)
        default:break;
        }
    }
}
    


