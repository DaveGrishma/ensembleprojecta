//
//  String+Extensions.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import Foundation
extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
