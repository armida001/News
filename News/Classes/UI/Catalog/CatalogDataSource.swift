//
//  CatalogDataSource.swift
//  News
//

import Foundation
import UIKit

class CatalogDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var newsArray: [NewsItem] = [NewsItem]()
    
    //MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.configure(newsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsArray[indexPath.row].opened = !newsArray[indexPath.row].opened
        newsArray[indexPath.row].readed = true
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return
        }
        cell.configure(newsArray[indexPath.row])
        
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    //MARK: common methods
    func startParser(completion: @escaping (()->Void)) {
        let parser: RSSParser = RSSParser()
        parser.startParse(completion: { [weak self] (response) in
            do {
                self?.newsArray = try response.get()
                self?.newsArray.sort(by: { (item, item2) -> Bool in
                    item.date > item2.date
                })
                completion()
            } catch let error  as NSError {
                print(error)
            }
        })
    }
}
