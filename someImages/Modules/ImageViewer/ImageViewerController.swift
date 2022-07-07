//
//  Controller.swift
//  someImages
//
//  Created by Рамиль Ахатов on 04.07.2022.
//

import UIKit
import Kingfisher

class ImageViewerController: UIViewController, UICollectionViewDelegate {
    var presenter: ImageViewerPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        setConstraints()
        addActionsToButtons()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToCurrentImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonLayer()
    }
    
    private func scrollToCurrentImage() {
        DispatchQueue.main.async {// Without main.async code there is a bug with scroll item on launching controller
            guard let item = self.presenter?.indexPath?.item else { return }
            self.collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    private func addActionsToButtons() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        sourceButton.addTarget(self, action: #selector(sourceButtonTapped), for: .touchUpInside)
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.isUserInteractionEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .myBackgroundGray
        button.setTitle("Previous", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .myBackgroundGray
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sourceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .myBackgroundGray
        button.setTitle("Source", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(sourceButton)
    }
    
    private func setupButtonLayer() {
        [previousButton, nextButton, sourceButton].forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
                                     collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     
                                     previousButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 40),
                                     previousButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                                     previousButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
                                     previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     
                                     nextButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 40),
                                     nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                                     nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
                                     nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                                     
                                     sourceButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0),
                                     sourceButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
                                     sourceButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                                     sourceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                                    ])
    }
    
    @objc func nextButtonTapped() {
        presenter?.showNextImage()
    }
    
    @objc func previousButtonTapped() {
        presenter?.showPreviousImage()
    }
    
    @objc func sourceButtonTapped() {
        presenter?.showSourceImage()
    }
}
//Presenter Delegate
extension ImageViewerController: ImageViewerProtocol {
    func didScrolledImageByTap(_ item: IndexPath.Element) {//Scroll over images by tap on buttons
        guard let item = self.presenter?.indexPath?.item else { return }
        self.collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension ImageViewerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.image?.imagesResults.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell,
              let stringUrl = presenter?.image?.imagesResults[indexPath.item].thumbnail else { return UICollectionViewCell()}
        cell.myImageView.contentMode = .scaleAspectFit
        cell.configureViewerModuleCell(withUrl: stringUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension ImageViewerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width, height: width)
    }
}


