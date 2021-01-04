//
//  BaseCollectionViewFlowLayout.swift
//  GiftClub
//
//  Created by 1 on 02.03.2020.
//  Copyright © 2020 Gmoji. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var contentHeightCalculate: (()->CGFloat)?
    var getDeletingAgentIndexPaths: (()->[IndexPath])?
    var headerLayoutAttributes: [Int : UICollectionViewLayoutAttributes] = [Int : UICollectionViewLayoutAttributes]()
    
    // 2. contentWidth
    private var contentWidth : CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    // 3. this will be calculated in Prepare()
    private var contentHeight : CGFloat = 0
    
    
    // 4. contentSize of collectionView
    // we just return the size that comprises of contentHeight and contentWidth
    // this property will be called after Prepare()
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // This is the meat of this class
    override func prepare() {
        // We don't need to call super
        contentHeight = self.contentHeightCalculate?() ?? 0
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: indexPath) {
            let oldFrame = attributes.frame
            attributes.frame = CGRect(x: 0, y: oldFrame.origin.y, width: self.collectionView?.bounds.width ?? oldFrame.width, height: oldFrame.height)
            return attributes
        }
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) {
            let oldFrame = attributes.frame
            attributes.frame = CGRect(x: 0, y: oldFrame.origin.y, width: self.collectionView?.bounds.width ?? oldFrame.width, height: oldFrame.height)
            self.headerLayoutAttributes[indexPath.section] = attributes
            return attributes
        }
        return nil
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) {
            attributes.alpha = 0
            return attributes
        }
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) {
            attributes.alpha = 0
            //deletingAgentIndexPaths - для выделения отдельной анимации удаления ячеек точек агента, все остальные ячейки удаляются по направлению к хэдеру секции
            if let deletingArray = self.getDeletingAgentIndexPaths?(), deletingArray.contains(itemIndexPath) {
                attributes.frame = CGRect.init(x: attributes.frame.origin.x, y: attributes.frame.origin.y, width: attributes.frame.width, height: attributes.frame.height)
                return attributes
            }
            if let headerAttr = self.collectionView?.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(row: 0, section: itemIndexPath.section)) {
                attributes.frame = CGRect.init(x: attributes.frame.origin.x, y: headerAttr.frame.origin.y+headerAttr.frame.height, width: attributes.frame.width, height: attributes.frame.height)
            } else {
                attributes.frame = CGRect.init(x: attributes.frame.origin.x, y: 0, width: attributes.frame.width, height: attributes.frame.height)
            }
            return attributes
        }
        return nil
    }
}
