//
//  NetworkDataFetcher.swift
//  someImages
//
//  Created by Рамиль Ахатов on 30.06.2022.
//

import Foundation

protocol NetworkDataFetcherProtocol {
    func fetchPlayerData(serchTerm: String, pages: String, completion: @escaping (Images?) -> Void)
}

class NetworkDataFetcher: NetworkDataFetcherProtocol {
    private let networkService = NetworkService()
    
    func fetchPlayerData(serchTerm: String, pages: String, completion: @escaping (Images?) -> Void) {
        networkService.request(searchTerm: serchTerm, pages: pages) { data, response ,error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            switch httpResponse.statusCode {
            case (0...200):
                let decode = self.decodeJSON(type: Images.self, from: data)
                completion(decode)
            case (201...400):
               
                completion(nil)
            default:
                completion(nil)
            }
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let imageData = try decoder.decode(type, from: data)
            return imageData
        } catch let jsonError {
            print(jsonError)
            return nil
        }
    }
}
