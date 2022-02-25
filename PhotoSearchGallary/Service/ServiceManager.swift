//
//  ServiceManager.swift
//  PhotoSearchGallary
//
//  Created by Geetha on 25/02/22.
//

import Foundation
import Combine

protocol Servicable {
    func doApiCall(apiRequest:Requestable)-> Future<Data, ServiceError>
}

class ServiceManager: Servicable {
    let session:URLSession
    init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    func doApiCall(apiRequest: Requestable) -> Future<Data, ServiceError> {
        return Future { [weak self] promise in
            guard let request = URLRequest.getURLRequest(for: apiRequest) else {
                promise(.failure(ServiceError.failedToCreateRequest))
                return
            }
            self?.session.dataTask(with: request, completionHandler: { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    return promise(.failure(ServiceError.dataNotFound))
                }
                guard let _data = data, error == nil else {
                    return promise(.failure(ServiceError.dataNotFound))
                }
                return promise(.success(_data))
            }).resume()
        }
    }
}

extension URLRequest {
    static func getURLRequest(for apiRequest:Requestable)-> URLRequest? {
        if let url = URL(string:apiRequest.baseUrl.appending(apiRequest.path)),
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
            let queryItems = apiRequest.params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            urlComponents.queryItems = queryItems
            let urlRequest = URLRequest(url: urlComponents.url!)
            return urlRequest
        } else {
            return nil
        }
    }
}
