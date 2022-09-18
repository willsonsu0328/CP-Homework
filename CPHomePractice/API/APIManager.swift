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

    func fetch(operationType: GQLOperationType = .query, query: GQLQueryProtocol, parameters: [String: Any]? = nil, completion: @escaping (_ response: URLResponse?, _ error: Error?, _ resultDataDict: [String: Any]?) -> Void) {

        guard let url = URL(string: baseURLString) else {
            // TODO: 定義 error
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
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    var resultDataDict: [String: Any]?
                    if let jsonDict = json as? [String: Any], let dataDict = jsonDict["data"] as? [String: Any] {
                        resultDataDict = dataDict
                    }
                    completion(response, error, resultDataDict)
                } catch _ {
                    // TODO: 定義 error
                    print("fail")
                }
            }
        }.resume()

    }
}

extension APIManager {

    func queryUsers(query: GQLQueryProtocol, completion: @escaping (_ response: URLResponse?, _ error: Error?, _ userModels: [UserModel]? ) -> Void) {
        APIManager.shared.fetch(query: query) { response, error, resultDataDict in
            var users: [UserModel]?
            if let userArray = resultDataDict?["users"] as? [Any], let data = try? JSONSerialization.data(withJSONObject: userArray, options: []) {
                users = try? JSONDecoder().decode([UserModel].self, from: data)
            }
            completion(response, error, users)
        }
    }

    func queryUser(query: GQLQueryProtocol, id: String = "", completion: @escaping (_ response: URLResponse?, _ error: Error?, _ userModel: UserModel? ) -> Void) {
        APIManager.shared.fetch(query: query, parameters: [
            "id": id
        ]) { response, error, resultDataDict in
            var user: UserModel?
            if let userDict = resultDataDict?["user"] as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: userDict, options: []) {
                user = try? JSONDecoder().decode(UserModel.self, from: data)
            }
            completion(response, error, user)
        }
    }

    func queryTodos(query: GQLQueryProtocol, completion: @escaping (_ response: URLResponse?, _ error: Error?, _ todoModels: [TodoModel]?) -> Void) {
        APIManager.shared.fetch(query: query) { response, error, resultDataDict in
            var todos: [TodoModel]?
            if let todoArray = resultDataDict?["todos"] as? [Any], let data = try? JSONSerialization.data(withJSONObject: todoArray, options: []) {
                todos = try? JSONDecoder().decode([TodoModel].self, from: data)
            }
            completion(response, error, todos)
        }
    }

    func mutationUpdateTodo(query: GQLQueryProtocol, parameters: [String: Any], completion: @escaping (_ response: URLResponse?, _ error: Error?, _ todoModel: TodoModel?) -> Void) {

        APIManager.shared.fetch(operationType: .mutation, query: query, parameters: parameters) { response, error, resultDataDict in
            var todo: TodoModel?
            if let todoDict = resultDataDict?["updateTodo"] as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: todoDict, options: []) {
                todo = try? JSONDecoder().decode(TodoModel.self, from: data)
            }
            completion(response, error, todo)
        }
    }
    
}
