//
//  Users.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/13.
//

import Foundation

struct Users: GQLQueryProtocol {
    var id: String = ""
    var name: String = ""
    var email: String = ""
}

struct User: GQLQueryProtocol {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var todos = Todo()
}
