//
//  UIViewController+Extension.swift
//  test
//
//  Created by Aleksey Kosov on 08.02.2023.
//

import UIKit

extension UIViewController {
    func presentDefaultError(title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
}
