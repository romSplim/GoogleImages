//
//  CollectionViewCell.swift
//  someImages
//
//  Created by Рамиль Ахатов on 04.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let myView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let myImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    func configureSearchModuleCell(withUrl: String) {
        guard let url = URL(string: withUrl) else { return }
        myImageView.kf.setImage(with: url, options: [.transition(.fade(0.25))])
    }
    
    func configureViewerModuleCell(withUrl: String) {
        guard let url = URL(string: withUrl) else { return }
        myImageView.kf.indicatorType = .activity
        (myImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
        myImageView.kf.setImage(with: url)
    }
    
    private  func setupLayout() {
        contentView.clipsToBounds = true
        contentView.addSubview(myView)
        contentView.addSubview(myImageView)
        NSLayoutConstraint.activate([myView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
                                     myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     myImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
}
