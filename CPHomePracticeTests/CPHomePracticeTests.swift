//
//  CPHomePracticeTests.swift
//  CPHomePracticeTests
//
//  Created by Wilson on 2022/9/11.
//

import XCTest
@testable import CPHomePractice

class CPHomePracticeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsers() throws {

        struct users: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        testStructToDictionary(someStruct: users())

        XCTAssertEqual(users().generateGQLString(), "{users{email\nid\nname}}")
    }

    func testUserWithParameter() throws {

        struct user: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        testStructToDictionary(someStruct: user())

        let userID = "4dc70521-22bb-4396-b37a-4a927c66d43b"

        let parameters = [
            "id": userID
        ]
        XCTAssertEqual(user().generateGQLString(parameters), "{user(id:" + "\"\(userID)\""  + "){email\nid\nname}}")
    }

    func testTodos() throws {

        struct todos: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
        }

        testStructToDictionary(someStruct: todos())
        XCTAssertEqual(todos().generateGQLString(), "{todos{description\nid}}")
    }

    func testUserTodos() throws {

        struct user: GQLQueryProtocol {
            var todos = todo()
        }

        struct todo: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
            var done: Bool = false
        }

        testStructToDictionary(someStruct: user())

        let userID = "someUser"

        let parameters = [
            "id": userID
        ]
        XCTAssertEqual(user().generateGQLString(parameters), "{user(id:" + "\"\(userID)\""  + "){todos{description\ndone\nid}}}")
    }

    func testMutationUpdateTodo() throws {

        struct updateTodo: GQLQueryProtocol {
            var id: String = ""
            var done: Bool = false
        }

        testStructToDictionary(someStruct: updateTodo())

        let parameters = [
            "input": [
                "id": "8db57b8f-be09-4e07-a1f6-4fb77d9b16e7",
                "done": true
            ]
        ]

        XCTAssertEqual(updateTodo().generateGQLString(operationType: .mutation, parameters), "mutation {updateTodo(input:{done:true,id:\"8db57b8f-be09-4e07-a1f6-4fb77d9b16e7\"}){done\nid}}")

    }

    func testStructToDictionary(someStruct: GQLQueryProtocol) {

        if let dict = someStruct.convertToDictionary() {
            Mirror(reflecting: someStruct).children.forEach { child in
                XCTAssertTrue(dict.contains(where: { ($0.key == child.label) }))
            }
        }

    }

    // 還需要寫 swift 轉 instance 測試

}
