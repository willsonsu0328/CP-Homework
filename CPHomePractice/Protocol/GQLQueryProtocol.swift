//
//  GQLProtocol.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/13.
//

import Foundation


protocol GQLQueryProtocol: StructConvertible {
    
}

extension GQLQueryProtocol {

    func generateGQLString(_ parameters: [String: Any]? = nil) -> String? {
        var queryString: String = ""

        if let dictionary = self.convertToDictionary() {
            queryString = recursiveDict(dictionary)

            // append struct name
            let structName = String(describing: type(of: self)).lowercased()

            // append parameters if needed
            if let parameters = parameters {
                let paramString: String = createParameterString(parameters)
                queryString = structName + paramString + queryString
            } else {
                queryString = structName + queryString
            }

            // wrap brackets
            queryString = "{" + queryString + "}"

            // debug
            print(queryString)
        }

        return queryString
    }

    private func recursiveDict(_ dictionary: [String: Any]) -> String {
        var string = ""
        string.append("{")
        for (index, key) in dictionary.keys.enumerated() {
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
        paramString += "("
        for (key, value) in parameters {
            paramString += "\(key)" + ":" + "\"\(value)\","
        }
        paramString.removeLast()
        paramString += ")"
        return paramString
    }
    
}


