//
//  NewsCell.swift
//  News
//

import Foundation
import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    var item: NewsItem?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var resourceLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    
    func configure(_ item: Any) {
        self.item = item as? NewsItem
        if let nItem = self.item {
            self.titleLabel?.text = nItem.title
            self.detailLabel?.text = nItem.detail
            self.dateLabel?.text = Date.defaultFormatString(from: nItem.date)
            self.resourceLabel?.text = nItem.resource?.url?.host
            if let imageURL = nItem.imageURL {
                self.logoImageView?.kf.setImage(with: ImageResource.init(downloadURL: imageURL), placeholder: nil, options: UIImage.sizedImageOptions(targetSize: self.logoImageView?.bounds.size ?? CGSize(width: 100, height: 100)), progressBlock: nil, completionHandler: { [weak self] image, error, type, url in
                    if let error = error, error.code == 10000 { self?.logoImageView?.image = #imageLiteral(resourceName: "product_default_icon") }
                    self?.logoImageView?.image = image
                })
            }
        }
    }
}
