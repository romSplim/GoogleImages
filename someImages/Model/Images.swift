//
//  Images.swift
//  someImages
//
//  Created by Рамиль Ахатов on 30.06.2022.
//

import Foundation

struct Images: Decodable {
    var imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImagesResult: Decodable {
    let position: Int?
    let thumbnail: String?
    let source, title: String?
    let link: String?
    let original: String?
    let isProduct: Bool?

    enum CodingKeys: String, CodingKey {
        case position, thumbnail, source, title, link, original
        case isProduct = "is_product"
    }
}
