//
//  NetworkService.swift
//  someImages
//
//  Created by Рамиль Ахатов on 30.06.2022.
//

import Foundation

class NetworkService {
    
    func request(searchTerm: String, pages: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let parameters = self.prepareParameters(searchTerm: searchTerm, pages: pages)
        let url = self.prepareUrl(params: parameters)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        let task = createDataTask(from: urlRequest, completion: completion)
        task.resume()
    }
    
    private func prepareParameters(searchTerm: String, pages: String) -> [String: String] {
        var params: [String: String] = [:]
        params["q"] = searchTerm
        params["tbm"] = "isch"
        params["engine"] = "google"
        params["ijn"] = pages
        params["api_key"] = "1b66bf83631935eac9672eaef5582abca1b158bf652abfa13a8fe90264a313fa"
        return params
    }
    
    private func prepareUrl(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "serpapi.com"
        components.path = "/search.json"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
    }
}



