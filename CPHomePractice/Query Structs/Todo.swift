//
//  Todo.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/13.
//

import Foundation

struct Todo: GQLQueryProtocol {
    var id: String = ""
    var description: String = ""
    var done: Bool = false
}
