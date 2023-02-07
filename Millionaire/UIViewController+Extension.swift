//
//  UIViewController+Extension.swift
//  TinkoffNews
//
//  Created by Aleksey Kosov on 05.02.2023.
//

import UIKit

extension UIViewController {
    func presentDefaultError(title: String, text: String) {
        let alert = UIAlertController(title: title,
                                      message: text,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title:
                                    NSLocalizedString("OK",
                                    comment: "OK"), style: .default) { _ in
        }
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
