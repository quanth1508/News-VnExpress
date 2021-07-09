//
//  NewsModel.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import Foundation

//MARK: - News Model
struct NewsModel {
    var title: String
    var imgSrc: String
    var pubDate: String
    var link: String
    var descriptionString: String
    
    var bookmarkTaped = false
    
    /// convert String pubDate type to Date pubDate type
    var datePubDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK_POSIX")
        dateFormatter.dateFormat = "E, d MMM yyy HH:mm:ss Z"
        let date = dateFormatter.date(from: pubDate)
        return date
    }
}


