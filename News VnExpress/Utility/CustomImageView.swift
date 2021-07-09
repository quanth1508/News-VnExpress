//
//  ImageExtension.swift
//  News VnExpress
//
//  Created by Quan Tran on 05/07/2021.
//

import UIKit
import Alamofire

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    // Load image from url string active on thread main
    func loadImageUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        AF.request(url).response { (responseData) in
            
            guard let data = responseData.data else {
                print("error = \(Error.self)")
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }
        
    }
    
    // Make image view to circle
    func makeToCircle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2
    }
    
}
