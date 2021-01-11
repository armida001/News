//
//  UIAlertViewControllerExtension.swift
//  News
//
//  Created by 1 on 11.01.2021.
//

import Foundation
import UIKit

extension UIAlertController {
    func addCancelAction() {
        self.addAction(UIAlertAction.init(title: "Отмена", style: UIAlertAction.Style.cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
    }
    
    static func wrongURLErrorAlert() -> UIAlertController {
        let errorAlert = UIAlertController.init(title: "Некоректный адрес ресурса", message: nil, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addCancelAction()
        return errorAlert
    }
    
    static func errorAlert() -> UIAlertController {
        let errorAlert = UIAlertController.init(title: "Ошибка загрузки", message: nil, preferredStyle: UIAlertController.Style.alert)
        errorAlert.addCancelAction()
        return errorAlert
    }
}
