//
//  User.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/17.
//

import Foundation

struct UserModel: Codable {

    var email: String?
    var id: String?
    var name: String?
    var todos: [TodoModel]?

    enum CodingKeys: String, CodingKey {
        case email
        case id
        case name
        case todos
    }

}
