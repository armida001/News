//
//  NewsCell.swift
//  News
//

import Foundation
import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    var item: NewsItem?
    
    func configure(_ item: Any) {
        self.item = item as? NewsItem
        if let nItem = self.item {
            self.textLabel?.text = nItem.title
            self.detailTextLabel?.text = nItem.detail
            if let imageURL = nItem.imageURL {
                self.imageView?.kf.setImage(with: ImageResource.init(downloadURL: imageURL), placeholder: nil, options: UIImage.sizedImageOptions(targetSize: self.imageView?.bounds.size ?? CGSize(width: 30, height: 30)), progressBlock: nil, completionHandler: { [weak self] image, error, type, url in
                    if let error = error, error.code == 10000 { self?.imageView?.image = #imageLiteral(resourceName: "product_default_icon") }
                    self?.imageView?.image = image
                })
            }
            self.textLabel?.adjustsFontSizeToFitWidth = true
        }
    }
}
