//
//  APIManager.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/15.
//

import UIKit

struct ResponseData<T: Codable>: Codable {
    let data: T
}

class APIManager: NSObject {

    static let shared = APIManager()

    let baseURLString = "https://api.mocki.io/v2/c4d7a195/graphql"

    func fetch<T: Codable>(operationType: GQLOperationType = .query, query: GQLQueryProtocol, parameters: [String: Any]? = nil, completion: @escaping (Result<ResponseData<T>, Error>) -> Void) {

        guard let url = URL(string: baseURLString) else {
            // error
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameter = [
            "query": query.generateGQLString(operationType: operationType, parameters)
        ]

        let data = try? JSONEncoder().encode(parameter)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let object = try? JSONDecoder().decode(ResponseData<T>.self, from: data)
                if let error = error {
                    completion(.failure(error))
                } else if let object = object {
                    completion(.success(object))
                }
            }
        }.resume()

    }
}
