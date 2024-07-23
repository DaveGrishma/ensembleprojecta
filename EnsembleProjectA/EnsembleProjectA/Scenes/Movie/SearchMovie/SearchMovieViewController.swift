//
//  SearchMovieViewController.swift
//  EnsembleProjectA
//
//  Created by Grishma Dave on 21/07/24.
//

import UIKit
import Combine

class SearchMovieViewController: UIViewController {
    
    @IBOutlet private var tableViewSearchResponse: UITableView!
    
    var searchTask: DispatchWorkItem?
    let searchController = UISearchController(searchResultsController: nil)
    var cancellable: Set <AnyCancellable> = []
    
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
        setUpBinding()
        setUpUIElements()
    }
    
    func setUpBinding() {
        viewModel.searchResult.sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.showNetworkError(error)
            }
        } receiveValue: { _ in
            self.tableViewSearchResponse?.reloadData()
        }.store(in: &cancellable)
    }
    
    func setUpUIElements() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Customize navigation bar appearance if needed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Movie"
    }
    
}

// MARK: - TableView DataSource
extension SearchMovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfMovies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.getCell(SearchMovieCell.self) else {
            return UITableViewCell()
        }
        cell.searchResponse = viewModel.movieAt(index: indexPath.row)
        return cell
    }
}

extension SearchMovieViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isBlank else {
            viewModel.clearSearch()
            return
        }
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchMovie(query: searchText)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
}
