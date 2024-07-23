//
//  SearchMovieCell.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import UIKit


class SearchMovieCell: UITableViewCell {
    
    @IBOutlet private var posterImageView: UIImageView?
    @IBOutlet private var textMovieTitle: UILabel?
    @IBOutlet private var textYearOfRealease: UILabel?
    
    var searchResponse: SearchResponse? {
        didSet {
            textMovieTitle?.text = searchResponse?.title
            textYearOfRealease?.text = searchResponse?.year
            if let poster = searchResponse?.poster {
                posterImageView?.loadImage(url: poster)
            }
        }
    }
}
