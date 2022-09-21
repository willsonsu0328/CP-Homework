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

    // MARK: Struct test

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

    // MARK: JSON to Swift instance test

    func decodeMockData<T: Codable>(jsonString: String = "") -> ResponseData<T>? {
        let data = jsonString.data(using: .utf8)
        guard let data = data else { return nil }
        let object = try? JSONDecoder().decode(ResponseData<T>.self, from: data)
        return object
    }

    func testUsersModels() throws {

        struct users: GQLQueryProtocol {
            var id: String = ""
            var email: String = ""
            var name: String = ""
        }
        let json = """
        {
          "data": {
            "users": [
              {
                "id": "Hello World",
                "email": "Hello World",
                "name": "Hello World"
              },
              {
                "id": "Hello World",
                "email": "Hello World",
                "name": "Hello World"
              },
              {
                "id": "Hello World",
                "email": "Hello World",
                "name": "Hello World"
              }
            ]
          }
        }
        """
        let responseData: ResponseData<UsersData>? = decodeMockData(jsonString: json)

        if let userModels = responseData?.data.users {
            for user in userModels {
                XCTAssertEqual(user.id, "Hello World")
                XCTAssertEqual(user.email, "Hello World")
                XCTAssertEqual(user.name, "Hello World")
            }
        } else {
            XCTAssert(false)
        }
    }

    func testUserModel() throws {

        struct user: GQLQueryProtocol {
            var id: String = ""
            var name: String = ""
            var email: String = ""
        }

        let json = """
        {
            "data": {
                "user": {
                    "id": "Hello World",
                    "email": "Hello World",
                    "name": "Hello World"
                }
            }
        }
        """

        let responeData: ResponseData<UserData>? = decodeMockData(jsonString: json)

        if let userModel = responeData?.data.user {
            XCTAssertEqual(userModel.id, "Hello World")
            XCTAssertEqual(userModel.email, "Hello World")
            XCTAssertEqual(userModel.name, "Hello World")
        } else {
            XCTAssert(false)
        }
    }

    func testTodoModels() throws {

        struct todos: GQLQueryProtocol {
            var id: String = ""
            var description: String = ""
        }

        let json = """
        {
          "data": {
            "todos": [
              {
                "id": "Hello World",
                "description": "Hello World"
              },
              {
                "id": "Hello World",
                "description": "Hello World"
              }
            ]
          }
        }
        """

        let responeData: ResponseData<TodosData>? = decodeMockData(jsonString: json)

        if let todoModels = responeData?.data.todos {
            for todo in todoModels {
                XCTAssertEqual(todo.id, "Hello World")
                XCTAssertEqual(todo.description, "Hello World")
            }
        } else {
            XCTAssert(false)
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

        let json = """
        {
          "data": {
            "user": {
              "todos": [
                {
                  "id": "Hello World",
                  "description": "Hello World",
                  "done": true
                },
                {
                  "id": "Hello World",
                  "description": "Hello World",
                  "done": true
                }
              ]
            }
          }
        }
        """

        let responeData: ResponseData<UserData>? = decodeMockData(jsonString: json)

        if let userModel = responeData?.data.user, let todos = userModel.todos {
            for todo in todos {
                XCTAssertEqual(todo.id, "Hello World")
                XCTAssertEqual(todo.description, "Hello World")
                XCTAssertEqual(todo.done, true)
            }
        } else {
            XCTAssert(false)
        }
    }

    func testMutationUpdateTodoModel() throws {

        struct updateTodo: GQLQueryProtocol {
            var id: String = ""
            var done: Bool = false
        }

        let json = """
        {
          "data": {
            "updateTodo": {
              "id": "Hello World",
              "done": false
            }
          }
        }
        """

        let responeData: ResponseData<UpdateTodoData>? = decodeMockData(jsonString: json)

        if let todoModel = responeData?.data.updateTodo {
            XCTAssertEqual(todoModel.id, "Hello World")
            XCTAssertEqual(todoModel.done, false)
        } else {
            XCTAssert(false)
        }

    }

}
