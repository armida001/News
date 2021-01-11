//
//  UIAlertViewControllerExtension.swift
//  News
//
//  Created by 1 on 11.01.2021.
//

import Foundation
import UIKit

extension UIAlertController {
    static func wrongURLErrorAlert() -> UIAlertController {
        let errorAlert = UIAlertController.init(title: "Некоректный адрес ресурса", message: nil, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addAction(UIAlertAction.init(title: "Отмена", style: UIAlertAction.Style.cancel, handler: { _ in
            errorAlert.dismiss(animated: true, completion: nil)
        }))
        return errorAlert
    }
}
