//
//  UIStackViewExtension.swift
//  GiftClub
//
//  Created by iOS Developer on 21/04/2019.
//  Copyright © 2019 simbirsoft. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllSubviews() {
        let removedSubviews = self.arrangedSubviews.reduce([]) {[weak self] (allSubviews, subview) -> [UIView] in
            self?.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        if !removedSubviews.isEmpty {
            NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
            removedSubviews.forEach({ $0.removeFromSuperview() })
            self.sizeToFit()
            self.layoutIfNeeded()
        }
    }
}
