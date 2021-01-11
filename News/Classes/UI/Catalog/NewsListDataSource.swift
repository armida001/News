//
//  CatalogDataSource.swift
//  News
//

import Foundation
import UIKit
import RxSwift

class NewsListDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
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
        SSDAO.init().deleteNews()
        parser.startParse(completion: { [weak self] (response) in
            do {
                guard let `self` = self else { return }
                let resultArray = try response.get()
                for item in resultArray {
                    if !self.newsArray.contains(where: {$0.link == item.link}) {
                        self.newsArray.append(item)
                        SSDAO.init().saveNews([item])
                    }
                }
                self.newsArray.sort(by: { (item, item2) -> Bool in
                    return item.date > item2.date
                })
                
                UserDefaults.setCustomObject(Date().timeIntervalSince1970, forKey: UserDefaultsKeys.lastUpdate)
                completion()
            } catch let error  as NSError {
                print(error)
            }
        })
    }
}
