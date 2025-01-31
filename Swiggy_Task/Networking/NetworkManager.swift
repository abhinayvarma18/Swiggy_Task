//
//  NetworkManager.swift
//  Swiggy_Task
//
//  Created by abhinay varma on 31/01/25.
//

import Foundation

protocol Networking {
    func getData<T: Codable>(_ request: URLRequest, completion: ((Result<T,Error>) -> Void)?)
    func createRequest(for url: String) throws -> URLRequest?
}

class NetworkManager: Networking {
    func createRequest(for url: String) throws -> URLRequest? {
        guard let url = URL(string: url) else { throw NetworkError.invalidUrl }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getData<T>(_ request: URLRequest, completion: ((Result<T, Error>) -> Void)?) where T : Decodable, T : Encodable {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion?(.failure(NetworkError.networkError))
                return
            }
            guard let data = data else {
                completion?(.failure(NetworkError.networkError))
                return
            }
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                completion?(.success(decodedResponse))
            } else {
                completion?(.failure(NetworkError.invalidData))
            }
        }
        dataTask.resume()
    }
}
enum NetworkError: Error {
    case invalidUrl
    case invalidData
    case networkError
    var message: String {
        switch self {
            case .invalidUrl: "Invalid URL"
            case .invalidData: "Error while parsing data"
            case .networkError: "Error with stock api server"
        }
    }
}
