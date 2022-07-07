//
//  SourceImagePresenter.swift
//  someImages
//
//  Created by Рамиль Ахатов on 04.07.2022.
//

import Foundation

protocol SourceImageViewProtocol: AnyObject {
    
}

protocol SourceImagePresenterProtocol: AnyObject {
    init(url: String, view: SourceImageViewProtocol)
    var url: String? { get set }
}

class SourceImagePresenter: SourceImagePresenterProtocol {
    weak var view: SourceImageViewProtocol?
    var url: String?
    
    required init(url: String, view: SourceImageViewProtocol) {
        self.view = view
        self.url = url
    }
    
    func showSourcePage(from url: String) {
        
        
    }
    
}
