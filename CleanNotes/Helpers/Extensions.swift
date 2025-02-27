//
//  Extensions.swift
//  CleanNotes
//
//  Created by Rijo Samuel on 25/02/25.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}
