//
//  TrendingManager.swift
//  Top Trending
//
//  Created by Quan Tran on 05/07/2021.
//

import Foundation
import Alamofire
//import Kanna

class NewsManager: NSObject, XMLParserDelegate {
    
    //MARK: - Properties
    
    var news = [NewsModel]()
    
    private var dataEncoding: Data?
    
    private var currentElement: String = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentImgSrc: String = "" {
        didSet {
            currentImgSrc = currentImgSrc.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescriptionString: String = "" {
        didSet {
            currentDescriptionString = currentDescriptionString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    //MARK: - Functions
    
    func fetchData(from url: String, completion: @escaping ([NewsModel]) -> Void) {
        
        AF.request(url).response { (responseData) in
        
            guard let safeData = responseData.data else {
                print("error = \(Error.self)")
                return
            }
            
            // parser XML safe data
            self.news.removeAll()
            let parser = XMLParser(data: safeData)
            parser.delegate  = self
            parser.parse()

            completion(self.news)
        }
}
    
    //MARK: - Parser XML Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentImgSrc = ""
            currentPubDate = ""
            dataEncoding = nil
            currentDescriptionString = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if currentElement == "description" {
    
            dataEncoding = CDATABlock
            
            let imgString = String(data: dataEncoding!, encoding: .utf8)
            let imgSrc = firstImgUrlString(imgString)
            currentImgSrc = imgSrc ?? ""
            
//            var descriptionString = ""
//            if let doc  = try? HTML(html: imgString!, encoding: .utf8) {
//                descriptionString = doc.text!
//            }
            
            let descriptionString = firstDescriptionString(imgString)
            currentDescriptionString = descriptionString ?? ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let new = NewsModel(title: currentTitle, imgSrc: currentImgSrc, pubDate: currentPubDate, link: currentLink, descriptionString: currentDescriptionString)
            
            self.news.append(new)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    // Use regex find image url
    func firstImgUrlString(_ string: String?) -> String? {
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(
                pattern: "(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?",
                options: .caseInsensitive)
        } catch let error {
            print("invalid regex = \(error.localizedDescription)")
        }

        let result = regex?.firstMatch (
            in: string ?? "",
            options: [],
            range: NSRange(location: 0, length: string?.count ?? 0))

        if let result = result {
            return (string as NSString?)?.substring(with: result.range(at: 2))
        }
        return nil
    }
    
    // Use regex find description with: "(?:</br>)([^]]*)(?:]*)"
    func firstDescriptionString(_ string: String?) -> String? {
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(
                pattern: "(?:</br>)([^]]*)(?:]*)",
                options: .caseInsensitive)
        } catch let error {
            print("invalid regex = \(error.localizedDescription)")
        }

        let result = regex?.firstMatch (
            in: string ?? "",
            options: [],
            range: NSRange(location: 0, length: string?.count ?? 0))

        if let result = result {
            return (string as NSString?)?.substring(with: result.range(at: 1))
        }
        return nil
    }
}
