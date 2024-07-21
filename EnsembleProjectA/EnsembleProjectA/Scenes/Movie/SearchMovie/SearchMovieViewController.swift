//
//  SearchMovieViewController.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import UIKit

class SearchMovieViewController: UIViewController {

    private let viewModel: SearchViewModelType
    required init?(coder: NSCoder, viewModel: SearchViewModelType) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
