//
//  RSSParser.swift
//  News
//

import Foundation
import FeedKit

class RSSParser: NSObject {
    private func loadFeed(resource: ResourceItem, data: Data, completion: @escaping (Swift.Result<[NewsItem], NewsItemLoadingError>) -> Void) {
        let parser = FeedParser(data: data)
        print(resource.url)
        parser.parseAsync { parseResult in
            let result: Swift.Result<[NewsItem], NewsItemLoadingError>
            do {
                switch parseResult {
                case .atom(let atom):
                    result = try .success(self.convert(atom: atom))
                    break
                case .rss(let rss):
                    result = try .success(self.convert(rss: rss, resource: resource))
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
    
    private func convert(rss: RSSFeed, resource: ResourceItem) throws -> [NewsItem] {
        var result: [NewsItem] = [NewsItem]()
        
        if let items = rss.items {
            for item in items {
                let p = NewsItem()
                p.title = item.title ?? ""
                p.link = URL.init(string: item.link ?? "")
                p.resource = resource
                p.author = item.author ?? ""
                let urlString = item.enclosure?.attributes?.url?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) as String? ?? ""
                p.imageURL = URL.init(string: urlString)
                p.detail = item.description ?? ""
                p.date = item.pubDate ?? Date()
                result.append(p)
            }
        }
        return result
    }
    
    private func convert(atom: AtomFeed) throws -> [NewsItem] {
        guard let name = atom.title else { throw NewsItemLoadingError.missingAttribute("title")  }
        
        let detail = atom.subtitle?.value ?? ""
        
        guard let logoURL = atom.logo.flatMap(URL.init) else {
            throw NewsItemLoadingError.missingAttribute("logo")
        }
        
        let p = NewsItem()
        p.title = name
        p.imageURL = logoURL
        p.detail = detail
        return [p]
    }
    
    func startParse(completion: @escaping (Swift.Result<[NewsItem], NewsItemLoadingError>) -> Void) {
        for resource in GlobalDefinition.shared.resourceItems {
            if let url = resource.url, resource.isActive {
                let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
                let dataTask = URLSession.shared.dataTask(with: req) { data, response, error in
                    if error == nil {
                        DispatchQueue.main.async {
                            //                completion(.failure(.networkingError(error)))
                            let http = response as! HTTPURLResponse
                            switch http.statusCode {
                            case 200:
                                if let data = data {
                                    self.loadFeed(resource: resource, data: data, completion: completion)
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
            }
        }
    }
}
