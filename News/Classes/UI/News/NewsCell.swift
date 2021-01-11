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
    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var resourceLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var moreImageView: UIImageView!
    @IBOutlet var indicatorView: UIView!
    
    func configure(_ item: Any) {
        self.item = item as? NewsItem
        if let nItem = self.item {
            self.titleLabel?.text = nItem.title
            self.detailLabel?.text = nItem.detail
            
            self.indicatorView.isHidden = nItem.readed
            self.moreImageView.image = (nItem.opened ? #imageLiteral(resourceName: "detailOpen") : #imageLiteral(resourceName: "detail"))
            self.detailLabel?.isHidden = !nItem.opened
            self.linkLabel?.isHidden = !nItem.opened
            
            if let linkString = nItem.link?.absoluteString {
                let attributedString = NSMutableAttributedString(string: linkString)
                attributedString.addAttribute(.link, value: linkString, range: NSRange(location: 0, length: linkString.count))
                self.linkLabel.attributedText = attributedString
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(linkClick))
                self.linkLabel.isUserInteractionEnabled = true
                self.linkLabel.addGestureRecognizer(tap)
            } else {
                self.linkLabel.isHidden = true
            }
            
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
    
    @objc func linkClick() {
        guard let url = self.item?.link else { return }
        UIApplication.shared.open(url)
    }
}
