//
//  RSSParser.swift
//  News
//
//  Created by 1 on 03.01.2021.
//

import Foundation
import FeedKit

class RSSParser: NSObject {
    let feedURL = URL(string: GlobalDefinition.lentaRSSHost)!
    var parser: FeedParser
    
    override init() {
        parser = FeedParser(URL: feedURL)
    }
    
    private func loadFeed(data: Data, completion: @escaping (Swift.Result<NewsItem, NewsItemLoadingError>) -> Void) {
        let parser = FeedParser(data: data)
        parser.parseAsync { parseResult in
            let result: Swift.Result<NewsItem, NewsItemLoadingError>
            do {
                switch parseResult {
                case .atom(let atom):
                    result = try .success(self.convert(atom: atom))
                    break
                case .rss(let rss):
                    result = try .success(self.convert(rss: rss))
                case .json(_): fatalError()
                case .failure(let e):
                    result = .failure(.feedParsingError(e))
                }
            } catch let e as NewsItemLoadingError {
                result = .failure(e)
            } catch {
                fatalError()
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func convert(rss: RSSFeed) throws -> NewsItem {
        let firstItem = rss.items?.first
        let title = firstItem?.title ?? ""
        let detail = firstItem?.description ?? ""
        
        let p = NewsItem()
        p.title = title
        p.resource = firstItem?.author ?? ""
        p.imageURL = URL.init(string: firstItem?.source?.value ?? "")
        p.detail = detail
        return p
    }
    
    private func convert(atom: AtomFeed) throws -> NewsItem {
        guard let name = atom.title else { throw NewsItemLoadingError.missingAttribute("title")  }

        let author = atom.authors?.compactMap({ $0.name }).joined(separator: ", ") ?? ""
        let detail = atom.subtitle?.value ?? ""
        
        guard let logoURL = atom.logo.flatMap(URL.init) else {
            throw NewsItemLoadingError.missingAttribute("logo")
        }

        let description = atom.subtitle?.value ?? ""

        let p = NewsItem()
        p.title = name
        p.resource = "atom"
        p.imageURL = logoURL
        p.detail = detail
        return p
    }
    
    func startParse() {
        let req = URLRequest(url: feedURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        let dataTask = URLSession.shared.dataTask(with: req) { data, response, error in
            if error == nil {
                DispatchQueue.main.async {
//                completion(.failure(.networkingError(error)))
                    let http = response as! HTTPURLResponse
                    switch http.statusCode {
                    case 200:
                        if let data = data {
                            self.loadFeed(data: data, completion: { result in
                                
                            })
                        }

                    case 404:
                        DispatchQueue.main.async {
//                            completion(.failure(.notFound))
                        }

                    case 500...599:
                        DispatchQueue.main.async {
//                            completion(.failure(.serverError(http.statusCode)))
                        }

                    default:
                        DispatchQueue.main.async {
//                            completion(.failure(.requestFailed(http.statusCode)))
                        }
                    }
                }
            return
            } else {
                print(error)
            }
        }
        
        dataTask.resume()
//
//        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
//            // Do your thing, then back to the Main thread
//
//            switch result {
//                case .atom(let feed):
//                    break       // Atom Syndication Format Feed Model
//                case .rss(let feed):
//                    break        // Really Simple Syndication Feed Model
//                case .json(let feed):
//                    break       // JSON Feed Model
//                case .failure(let error):
//                    print(error)
//            }
//
////            DispatchQueue.main.async {
////                // ..and update the UI
////            }
//        }
    }
}

//class RSSParser: NSObject, NSXMLParserDelegate {
//    var parser: NSXMLParser?
//
//    init() {
//        parser = NSXMLParser(contentsOfURL:(NSURL(string: GlobalDefinition.gazetaRSSHost)))
//        parser.delegate = self
//        parser.parse()
//    }
//
//    //MARK: - XMLParser Delegate
//
//        func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
//            println("parse error: \(parseError)")
//        }
//
//        func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
//            tempElement = elementName
//            if elementName == "item" {
//                tempPost = Post(title: "", link: "", date: "")
//            }
//        }
//
//        func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//            if elementName == "item" {
//                if let post = tempPost {
//                    posts.append(post)
//                }
//                tempPost = nil
//            }
//        }
//
//        func parser(parser: NSXMLParser, foundCharacters string: String?) {
//            if let post = tempPost, let str = string {
//                if tempElement == "title" {
//                    tempPost?.title = post.title+str
//                } else if tempElement == "link" {
//                    tempPost?.link = post.link+str
//                } else if tempElement == "pubDate" {
//                    tempPost?.date = post.date+str
//                }
//            }
//        }
//}
