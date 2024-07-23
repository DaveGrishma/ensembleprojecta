//
//  DispatchQueue+Extentions.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 22/07/24.
//

import Foundation

extension DispatchQueue {
    static func dispatchMain(complition: @escaping(() -> Void)) {
        if Thread.isMainThread {
            complition()
        } else {
            DispatchQueue.main.async {
                complition()
            }
        }
    }
}
