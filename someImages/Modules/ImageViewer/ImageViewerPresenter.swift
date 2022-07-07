//
//  Presenter.swift
//  someImages
//
//  Created by Рамиль Ахатов on 04.07.2022.
//

import Foundation

protocol ImageViewerProtocol: AnyObject {
    func didScrolledImageByTap(_ item: IndexPath.Element)
}

protocol ImageViewerPresenterProtocol: AnyObject {
    init(image: Images, view: ImageViewerProtocol, router: RouterProtocol, indexPath: IndexPath)
    var view: ImageViewerProtocol? { get set }
    var indexPath: IndexPath! { get set }
    var image: Images? { get set }
    func showNextImage()
    func showPreviousImage()
    func showSourceImage()
}

class ImageViewerPresenter: ImageViewerPresenterProtocol {
    weak var view: ImageViewerProtocol?
    var router: RouterProtocol?
    var image: Images?
    var indexPath: IndexPath!
    
    required init(image: Images, view: ImageViewerProtocol, router: RouterProtocol, indexPath: IndexPath) {
        self.view = view
        self.router = router
        self.image = image
        self.indexPath = indexPath
    }
    
    func showNextImage() {
        if (indexPath?.item ?? 0) <= (image?.imagesResults.count)! - 1 {
            indexPath.item += 1
            self.view?.didScrolledImageByTap(indexPath.item)
        }
    }
    
    func showPreviousImage() {
        if (indexPath?.item ?? 0) >= 1 {
            indexPath?.item -= 1
            self.view?.didScrolledImageByTap(indexPath?.item ?? 0)
        }
    }
    
    func showSourceImage() {
        guard let currentImageUrl = image?.imagesResults[indexPath?.item ?? 0].original else { return }
        router?.showSourceController(with: currentImageUrl)
    }
}
