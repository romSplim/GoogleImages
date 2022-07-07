//
//  Router.swift
//  someImages
//
//  Created by Рамиль Ахатов on 02.07.2022.
//

import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
    func initialController()
    func showDetail(with url: Images, indexPath: IndexPath)
    func showSourceController(with url: String)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialController() {
        guard let navigationController = navigationController,
              let mainViewController = assemblyBuilder?.createSearchModule(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func showDetail(with url: Images, indexPath: IndexPath) {
        guard let navigationController = navigationController,
              let detailViewController = assemblyBuilder?.createImageViewerModule(image: url, router: self, indexPath: indexPath) else { return }
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func showSourceController(with url: String) {
        guard let navigationController = navigationController,
              let detailViewController = assemblyBuilder?.createSourceImageModule(url: url, router: self) else { return }
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }

}
