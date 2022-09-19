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

    // MARK: Json to Swift instance test

    func testUsersModels() throws {

        struct users: GQLQueryProtocol {
            var id: String = ""
            var email: String = ""
            var name: String = ""
        }

        let expectation = self.expectation(description: "Waiting for the queryUsers call to complete.")

        var userArray: [UserModel]?
        APIManager.shared.queryUsers(query: users()) { response, error, userModels in
            userArray = userModels
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { error in
            if let userArray = userArray {
                for user in userArray {
                    XCTAssertEqual(user.id, "Hello World")
                    XCTAssertEqual(user.email, "Hello World")
                    XCTAssertEqual(user.name, "Hello World")
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testUserModel() throws {

        struct user: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        let expectation = self.expectation(description: "Waiting for the queryUserWithID call to complete.")

        var userData: UserModel?
        APIManager.shared.queryUser(query: user(), id: "4dc70521-22bb-4396-b37a-4a927c66d43b") { response, error, userModel in
            userData = userModel
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { _ in
            if let userData = userData {
                XCTAssertEqual(userData.id, "Hello World")
                XCTAssertEqual(userData.email, "Hello World")
                XCTAssertEqual(userData.name, "Hello World")
            } else {
                XCTAssert(false)
            }
        }
    }

    func testTodoModels() throws {

        struct todos: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
        }

        let expectation = self.expectation(description: "Waiting for the queryTodos call to complete.")

        var todoArray: [TodoModel]?
        APIManager.shared.queryTodos(query: todos()) { response, error, todoModels in
            todoArray = todoModels
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { _ in
            if let todoArray = todoArray {
                for todo in todoArray {
                    XCTAssertEqual(todo.id, "Hello World")
                    XCTAssertEqual(todo.description, "Hello World")
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testUserTodoModels() throws {

        struct user: GQLQueryProtocol {
            var todos = todo()
        }

        struct todo: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
            var done: Bool = false
        }

        let expectation = self.expectation(description: "Waiting for the quertyUserTodos call to complete.")

        var userData: UserModel?
        APIManager.shared.queryUser(query: user(), id: "someUser") { response, error, userModel in
            userData = userModel
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { _ in
            if let userData = userData, let todos = userData.todos {
                for todo in todos {
                    XCTAssertEqual(todo.id, "Hello World")
                    XCTAssertEqual(todo.description, "Hello World")
                    XCTAssertEqual(todo.done, true)
                }
            } else {
                XCTAssert(false)
            }
        }
    }

    func testMutationUpdateTodoModel() throws {

        struct updateTodo: GQLQueryProtocol {
            var id: String = ""
            var done: Bool = false
        }

        let parameters: [String: Any] = [
            "input": [
                "id": "8db57b8f-be09-4e07-a1f6-4fb77d9b16e7",
                "done": true
            ]
        ]

        let expectation = self.expectation(description: "Waiting for the mutationUpdateTodo call to complete.")

        var todoData: TodoModel?
        APIManager.shared.mutationUpdateTodo(query: updateTodo(), parameters: parameters) { response, error, todoModel in
            todoData = todoModel
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { _ in
            if let todoData = todoData {
                XCTAssertEqual(todoData.id, "Hello World")
                XCTAssertEqual(todoData.done, false)
            } else {
                XCTAssert(false)
            }
        }

    }

}
