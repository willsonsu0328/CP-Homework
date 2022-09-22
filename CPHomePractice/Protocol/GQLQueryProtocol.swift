//
//  GQLProtocol.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/13.
//

import Foundation

enum GQLOperationType: String {
    case query
    case mutation
}

protocol GQLQueryProtocol: Codable {

}

extension GQLQueryProtocol {

    func generateGQLString(operationType: GQLOperationType = .query, _ parameters: [String: Any]? = nil) -> String {
        var queryString: String = ""

        if let dictionary = self.convertToDictionary() {
            queryString = recursiveDict(dictionary)

            // append struct name
            let structName = String(describing: type(of: self))

            // append parameters if needed
            if let parameters = parameters {
                let paramString = "(" + createParameterString(parameters) + ")"
                queryString = structName + paramString + queryString
            } else {
                queryString = structName + queryString
            }

            // wrap brackets
            let wrapQuery = "{" + queryString + "}"

            // query or mutation
            switch operationType {
            case .query:
                queryString = wrapQuery
            case .mutation:
                queryString = operationType.rawValue + " " + wrapQuery
            }

            // debug
            print("GraphQL Query String: \n\n" + "\(queryString)" + "\n")
        }

        return queryString
    }

    func convertToDictionary() -> [String: Any]? {

        var dict: [String: Any]?

        do {
            let data = try JSONEncoder().encode(self)
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
            print(error)
        }

        return dict
    }

    private func recursiveDict(_ dictionary: [String: Any]) -> String {
        var string = ""
        string.append("{")
        let keys = dictionary.keys.sorted { $0 < $1 }
        for (index, key) in keys.enumerated() {
            if let value = dictionary[key] as? [String: Any] {
                string.append(key)
                string.append(recursiveDict(value))
            } else {
                string.append(key)
                if index != dictionary.keys.count - 1 {
                    string.append("\n")
                }
            }
        }
        string.append("}")
        return string
    }

    private func createParameterString(_ parameters: [String: Any]) -> String {
        var paramString: String = ""
        let sortedParamtersKeys = parameters.keys.sorted { $0 < $1 }
        for key in sortedParamtersKeys {
            let value = parameters[key]
            if let dict = value as? [String: Any] {
                paramString.append("\(key)" + ":")
                paramString.append("{")
                paramString.append(createParameterString(dict))
                paramString.append("}")
                paramString.append(",")
            } else {
                if let stringValue = value as? String {
                    paramString.append("\(key)" + ":" + "\"\(stringValue)\",")
                } else {
                    paramString.append("\(key)" + ":" + "\(value ?? ""),")
                }
            }
        }
        paramString.removeLast()
        return paramString
    }
    
}


