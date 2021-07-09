//
//  BookmarkModel.swift
//  News VnExpress
//
//  Created by Quan Tran on 09/07/2021.
//

import Foundation
import RealmSwift

final class BookmarkModel: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var imgSrc: String = ""
    @objc dynamic var pubDate: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var descriptionString: String = ""
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
    class func toBookmarkModel(fromModel: NewsModel) -> BookmarkModel {
        let item = BookmarkModel()
        
        item.title = fromModel.title
        item.descriptionString = fromModel.descriptionString
        item.imgSrc = fromModel.imgSrc
        item.link = fromModel.link
        item.pubDate = fromModel.datePubDate?.since ?? "10 giờ trước"
        
        return item
    }
    
}
