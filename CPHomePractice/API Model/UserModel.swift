//
//  User.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/17.
//

import Foundation

struct UserData: Codable {
    let user: UserModel
}

struct UsersData: Codable {
    let users: [UserModel]
}

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
