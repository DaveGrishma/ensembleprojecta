//
//  UIViewController+Extentions.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 22/07/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showNetworkError(_ error: NetworkRequestError) {        
        DispatchQueue.dispatchMain {
            let alertController: UIAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true)
        }
    }
}
