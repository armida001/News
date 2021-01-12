//
//  RSSParser.swift
//  News
//

import Foundation
import FeedKit

class RSSParser: NSObject {
    private func loadFeed(resource: ResourceItem, data: Data, completion: @escaping (Swift.Result<[NewsItem], NewsItemLoadingError>) -> Void) {
        let parser = FeedParser(data: data)
        parser.parseAsync { parseResult in
            let result: Swift.Result<[NewsItem], NewsItemLoadingError>
            do {
                switch parseResult {
                case .rss(let rss):
                    result = try .success(self.convert(rss: rss, resource: resource))
                case .failure(let e):
                    result = .failure(.feedParsingError(e))
                default: fatalError()
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
                let nobject = NewsItem()
                nobject.title = item.title ?? ""
                nobject.link = URL.init(string: item.link ?? "")
                nobject.resource = resource
                nobject.author = item.author ?? ""
                let urlString = item.enclosure?.attributes?.url?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) as String? ?? ""
                nobject.imageURL = URL.init(string: urlString)
                nobject.detail = item.description ?? ""
                nobject.date = item.pubDate ?? Date()
                result.append(nobject)
            }
        }
        return result
    }
    
    func startParse(completion: @escaping (Swift.Result<[NewsItem], NewsItemLoadingError>) -> Void) {
        for resource in GlobalDefinition.shared.resourceItems {
            if let url = resource.url, resource.isActive {
                let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
                let dataTask = URLSession.shared.dataTask(with: req) { data, response, error in
                    if let nerror = error {
                        completion(.failure(.networkingError(nerror)))
                    } else {
                        DispatchQueue.main.async {
                            let http = response as! HTTPURLResponse
                            switch http.statusCode {
                            case 200:
                                if let data = data {
                                    self.loadFeed(resource: resource, data: data, completion: completion)
                                }
                                break
                            case 404:
                                DispatchQueue.main.async {                                                                completion(.failure(.notFound))
                                }
                                
                            case 500...599:
                                DispatchQueue.main.async {
                                    completion(.failure(.serverError(http.statusCode)))
                                }
                                
                            default:
                                DispatchQueue.main.async {
                                    completion(.failure(.requestFailed(http.statusCode)))
                                }
                            }
                        }
                        return
                    }
                }
                
                dataTask.resume()
            }
        }
    }
}
