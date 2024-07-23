//
//  UIImage+Extensions.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: String) {
        self.kf.setImage(with: URL(string: url))
    }
}
