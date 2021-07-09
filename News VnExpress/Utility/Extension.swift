//
//  Extension.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import Foundation

extension Date {
    
    // custom date time ago publish at video
    var since: String {
        get {
            let start = self
            let end = Date()
            
            let components = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: start, to: end)
            
            var significance: String = ""
            if let years = components.year, years > 0 {
                significance = years == 1 ? "\(years) năm" : "\(years) năm"
            }
            else if let months = components.month, months > 0 {
                significance = months == 1 ? "\(months) tháng" : "\(months) tháng"
            }
            else if let weeks = components.weekOfYear, weeks > 0 {
                significance = weeks == 1 ? "\(weeks) tuần" : "\(weeks) tuần"
            }
            else if let days = components.day, days > 0 {
                significance = days == 1 ? "\(days) ngày" : "\(days) ngày"
            }
            else if let hours = components.hour, hours > 0 {
                significance = hours == 1 ? "\(hours) giờ" : "\(hours) giờ"
            }
            else if let minutes = components.minute, minutes > 0 {
                significance = minutes == 1 ? "\(minutes) phút" : "\(minutes) phút"
            }
            else if let seconds = components.second, seconds > 0 {
                significance = seconds == 1 ? "\(seconds) giây" : "\(seconds) giây"
            }
            return "\(significance) trước"
        }
    }
}
