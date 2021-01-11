//
//  UIImageExtension.swift
//

import UIKit
import Kingfisher

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static func imageOptions(targetSize: CGSize) -> KingfisherOptionsInfo {
        let scaleFactor = UIScreen.main.scale
        let resizer = ResizingImageProcessor(referenceSize: CGSize(width: targetSize.width,
                                                                   height: targetSize.height),
                                             mode: .aspectFit)
        return [
            .scaleFactor(scaleFactor),
            .processor(resizer),
            .transition(.fade(0.15))
        ]
    }
       
    static func sizedImageOptions(targetSize: CGSize) -> KingfisherOptionsInfo {
        let scaleFactor = UIScreen.main.scale
        let resizer = ResizingImageProcessor(referenceSize: CGSize(width: targetSize.width,
                                                                   height: targetSize.height),
                                             mode: .aspectFit)
        return [
            .scaleFactor(scaleFactor),
            .processor(resizer),
            .transition(.fade(0.15))
        ]
    }
}
