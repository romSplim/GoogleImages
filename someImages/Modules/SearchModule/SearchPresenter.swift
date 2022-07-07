//
//  SearchPresenter.swift
//  someImages
//
//  Created by Рамиль Ахатов on 30.06.2022.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    var presenter: SearchPresenterProtocol? { get set }
    func didRecieveSearchResult()
    func hideLoadingProcess()
}

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewProtocol, networkService: NetworkDataFetcher, router: RouterProtocol)
    var images: Images? { get set }
    func getImages(searchTerm: String)
    func tapOnImageItem(with url: Images, indexPath: IndexPath)
    func loadNextPage(searchTerm: String)
    var pageNum: Int! { get set }
}

class SearchPresenter: SearchPresenterProtocol {
    var images: Images?
    var networkService: NetworkDataFetcher?
    var router: RouterProtocol?
    var pageNum: Int! = 0
    
    weak var view: SearchViewProtocol?
    
    required init(view: SearchViewProtocol, networkService: NetworkDataFetcher, router: RouterProtocol) {
        self.networkService = networkService
        self.view = view
        self.router = router
    }
    
    func getImages(searchTerm: String) {
        pageNum = 0
        networkService?.fetchPlayerData(serchTerm: searchTerm, pages: String(pageNum)) { [weak self] images in
            guard let self = self,
                  let images = images else { return }
            DispatchQueue.main.async {
                self.images = images
                self.view?.didRecieveSearchResult()
                self.view?.hideLoadingProcess()
            }
        }
    }
    
    func loadNextPage(searchTerm: String) {
        pageNum += 1
        networkService?.fetchPlayerData(serchTerm: searchTerm, pages: String(pageNum)) { [weak self] images in
            guard let self = self,
                  let images = images else { return }
            DispatchQueue.main.async {
                self.images?.imagesResults.append(contentsOf: images.imagesResults)
                self.view?.didRecieveSearchResult()
            }
        }
    }
    
    func tapOnImageItem(with url: Images, indexPath: IndexPath) {
        router?.showDetail(with: url, indexPath: indexPath)
    }
}
