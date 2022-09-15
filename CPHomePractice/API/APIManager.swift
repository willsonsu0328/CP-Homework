//
//  APIManager.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/15.
//

import UIKit

class APIManager: NSObject {

    static let shared = APIManager()

    let baseURLString = "https://api.mocki.io/v2/c4d7a195/graphql"

    func fetch(query: GQLQueryProtocol, parameters: [String: Any]? = nil, completion: @escaping (_ response: URLResponse?, _ error: Error?, _ resultDict: [String: Any]?) -> Void) {

        guard let url = URL(string: baseURLString) else {
            // TODO: 定義 error
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameter = [
            "query": query.generateGQLString(parameters)
        ]

        let data = try? JSONEncoder().encode(parameter)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    var resultDict: [String: Any]?
                    if let dict = json as? [String: Any] {
                        resultDict = dict
                    }
                    completion(response, error, resultDict)
                } catch _ {
                    // TODO: 定義 error
                    print("fail")
                }
            }
        }.resume()

    }
}
