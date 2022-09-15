//
//  StructConvertible.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/13.
//

import Foundation

protocol StructConvertible: Codable {

}

extension StructConvertible {

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
}


