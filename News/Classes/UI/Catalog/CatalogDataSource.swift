//
//  CatalogDataSource.swift
//  News
//

import Foundation
import UIKit

class CatalogDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var newsArray: [NewsItem] = [NewsItem]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.configure(newsArray[indexPath.row])
        return cell
    }
    
    func startParser(completion: @escaping (()->Void)) {
        let parser: RSSParser = RSSParser()
        parser.startParse(completion: { [weak self] (response) in
            do {
                self?.newsArray = try response.get()
                completion()
            } catch let error  as NSError {
                print(error)
            }
        })
    }
}
