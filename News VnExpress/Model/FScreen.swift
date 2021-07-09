//
//  FScreen.swift
//  News VnExpress
//
//  Created by Quan Tran on 06/07/2021.
//

import Foundation

//MARK: - Enum Title
enum FScreen: String, CaseIterable {
    case trangchu =  "Trang chủ"
    case tinxemnhieu = "Tin xem nhiều"
    case thegioi = "Thế giới"
    case thoisu = "Thời sự"
    case kinhdoanh = "Kinh doanh"
    case startup = "Startup"
    case giaitri = "Giải trí"
    case thethao = "Thể thao"
    case phapluat = "Pháp luật"
    case giaoduc = "Giáo dục"
    case tinnoibat = "Tin nổi bật"
    case doisong = "Đời sống"
    case suckhoe = "Sức khoẻ"
    case dulich = "Du lịch"
    case khoahoc = "Khoa học"
    case sohoa = "Số hoá"
    case xe = "Xe"
    case ykien = "Ý kiến"
    case tamsu = "Tâm sự"
    case cuoi = "Cười"
}


//MARK: - Enum Urls Category used to parser XML
enum UrlFscreen: String {
    case trangchu =  "https://vnexpress.net/rss/tin-moi-nhat.rss"
    case thegioi = "https://vnexpress.net/rss/the-gioi.rss"
    case thoisu = "https://vnexpress.net/rss/thoi-su.rss"
    case kinhdoanh = "https://vnexpress.net/rss/kinh-doanh.rss"
    case startup = "https://vnexpress.net/rss/startup.rss"
    case giaitri = "https://vnexpress.net/rss/giai-tri.rss"
    case thethao = "https://vnexpress.net/rss/the-thao.rss"
    case phapluat = "https://vnexpress.net/rss/phap-luat.rss"
    case giaoduc = "https://vnexpress.net/rss/giao-duc.rss"
    case tinnoibat = "https://vnexpress.net/rss/tin-noi-bat.rss"
    case suckhoe = "https://vnexpress.net/rss/suc-khoe.rss"
    case doisong = "https://vnexpress.net/rss/gia-dinh.rss"
    case dulich = "https://vnexpress.net/rss/du-lich.rss"
    case khoahoc = "https://vnexpress.net/rss/khoa-hoc.rss"
    case sohoa = "https://vnexpress.net/rss/so-hoa.rss"
    case xe = "https://vnexpress.net/rss/oto-xe-may.rss"
    case ykien = "https://vnexpress.net/rss/y-kien.rss"
    case tamsu = "https://vnexpress.net/rss/tam-su.rss"
    case cuoi = "https://vnexpress.net/rss/cuoi.rss"
    case tinxemnhieu = "https://vnexpress.net/rss/tin-xem-nhieu.rss"
}

