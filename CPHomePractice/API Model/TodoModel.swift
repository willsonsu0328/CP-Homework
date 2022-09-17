//
//  TodoModel.swift
//  CPHomePractice
//
//  Created by Wilson on 2022/9/17.
//

import Foundation

struct TodoModel: Codable {

    var id: String?
    var description: String?
    var done: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case done
    }

}
