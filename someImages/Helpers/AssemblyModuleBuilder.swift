//
//  Coordinator.swift
//  someImages
//
//  Created by Рамиль Ахатов on 30.06.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createSearchModule(router: RouterProtocol) -> UIViewController
    func createImageViewerModule(image: Images, router: RouterProtocol, indexPath: IndexPath) -> UIViewController
    func createSourceImageModule(url: String, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createSearchModule(router: RouterProtocol) -> UIViewController {
        let view = SearchViewController()
        let networkService = NetworkDataFetcher()
        let presenter = SearchPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createImageViewerModule(image: Images, router: RouterProtocol, indexPath: IndexPath) -> UIViewController {
        let view = ImageViewerController()
        let presenter = ImageViewerPresenter(image: image, view: view, router: router, indexPath: indexPath)
        view.presenter = presenter
        return view
    }
    
    func createSourceImageModule(url: String, router: RouterProtocol) -> UIViewController {
        let view = SourceImageController()
        let presenter = SourceImagePresenter(url: url, view: view)
        view.presenter = presenter
        return view
    }
}
