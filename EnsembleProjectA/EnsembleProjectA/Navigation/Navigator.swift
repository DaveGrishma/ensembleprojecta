//
//  Navigator.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import UIKit

enum UserEntryFlow {
    case searchMovie
}

protocol NavigatorType {
    func start(with flow: UserEntryFlow)
}

class Navigator : NavigatorType {
    let navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start(with flow: UserEntryFlow) {
        switch flow {
        case .searchMovie:
            <#code#>
        }
    }
    
}
