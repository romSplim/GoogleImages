//
//  UIViewController+Extension.swift
//  someImages
//
//  Created by Рамиль Ахатов on 07.07.2022.
//

import UIKit

extension UIView {
    func addSubviews(view: [UIView]) {
        view.forEach { eachView in
            self.addSubview(eachView)
        }
    }
}
