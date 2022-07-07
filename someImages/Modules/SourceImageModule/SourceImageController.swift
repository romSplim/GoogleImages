//
//  ViewController.swift
//  someImages
//
//  Created by Рамиль Ахатов on 04.07.2022.
//

import UIKit
import WebKit

class SourceImageController: UIViewController, SourceImageViewProtocol {
    var presenter: SourceImagePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setConstraints()
        loadSourcePage()
    }
    
    private func loadSourcePage() {
        guard let stringUrl = presenter?.url,
              let sourceUrl = URL(string: stringUrl) else { return }
        let request = URLRequest(url: sourceUrl)
        webView.load(request)
    }
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private func addSubview() {
        view.addSubview(webView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([webView.topAnchor.constraint(equalTo: view.topAnchor),
                                     webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
