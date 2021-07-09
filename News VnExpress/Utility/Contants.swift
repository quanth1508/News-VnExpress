//
//  Contants.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import Foundation
import RealmSwift

struct Contants {
    
    struct Identifier {
        static var cellMenuIdentifier = "MenuTableViewCell"
        static var cellMenuNibName = "MenuTableViewCell"
        static var cellNewsIdentifier = "NewsTableViewCell"
        static var cellNewsNibName = "NewsTableViewCell"
        static var cellBookmarkIdentifier = "BookMarkTableViewCell"
        static var cellBookmarkNibName = "BookMarkTableViewCell"
    }
    
    struct Color {
        static var titleColor = "Color Title"
        static var textBarColor = "Color Text Bar"
        static var barColor = "Color Bar"
    }
    
    static let realm = try! Realm()
}
