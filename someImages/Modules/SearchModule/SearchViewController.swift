//
//  ViewController.swift
//  someImages
//
//  Created by Рамиль Ахатов on 30.06.2022.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addSubviews()
        setConstraints()
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    private func addSubviews() {
        view.addSubviews(view: [collectionView, activityIndicator])
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "GoogleImages"
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        return indicator
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        return collectionView
    }()
    
    private func setConstraints() {
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     
                                     activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
                                     activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func showLoadingProcess() {
        activityIndicator.startAnimating()
        collectionView.isHidden = true
    }
    
}

//Presenter Delegate
extension SearchViewController: SearchViewProtocol {
    
    func didRecieveSearchResult() {
        collectionView.reloadData()
    }
    
    func hideLoadingProcess() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
    }
}

//UICollectionView DataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.images?.imagesResults.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let urlString = presenter?.images?.imagesResults[indexPath.item].thumbnail ?? ""
        cell.configureSearchModuleCell(withUrl: urlString)
        return cell
    }
}

//UICollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let images = presenter?.images else { return }
        presenter?.tapOnImageItem(with: images, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let imagesCount = presenter?.images?.imagesResults.count else { return }
        if indexPath.item == imagesCount - 1 {
            presenter?.loadNextPage(searchTerm: searchController.searchBar.text ?? "")
        }
    }
}

//UICollectionView DelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 6 - 1
        return CGSize(width: width, height: width)
    }
}

//UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        presenter?.getImages(searchTerm: searchText)
        showLoadingProcess()
    }
}
