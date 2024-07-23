//
//  UITableView+Extensions.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import UIKit

extension UITableView {
    
    func getCell<T: UITableViewCell>(_ type: T.Type) -> T?{
        let identifier = String(describing: type)
        if let cell = dequeueReusableCell(withIdentifier: identifier) as? T {
            return cell
        }
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        return getCell(type)
    }
}
